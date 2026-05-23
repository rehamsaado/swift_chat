import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { create } from "https://deno.land/x/djwt@v2.8/mod.ts"

serve(async (req) => {
  const { record } = await req.json()

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
  )

  // 1. البحث عن المستلم
  const { data: member } = await supabase
    .from('room_members')
    .select('user_id')
    .eq('room_id', record.room_id)
    .neq('user_id', record.sender_id)
    .single()

  if (member) {
    const { data: profile } = await supabase
      .from('profiles')
      .select('fcm_token')
      .eq('id', member.user_id)
      .single()

    if (profile?.fcm_token) {
      const clientEmail = Deno.env.get('FIREBASE_CLIENT_EMAIL')!
      const privateKeyRaw = Deno.env.get('FIREBASE_PRIVATE_KEY')!
      const projectId = Deno.env.get('FIREBASE_PROJECT_ID')!

      // --- تنظيف المفتاح الخاص ---
      const privateKey = privateKeyRaw.replace(/\\n/g, '\n')
      const pemHeader = "-----BEGIN PRIVATE KEY-----";
      const pemFooter = "-----END PRIVATE KEY-----";
      let pemContents = privateKey.trim();

      if (pemContents.startsWith(pemHeader)) pemContents = pemContents.substring(pemHeader.length);
      if (pemContents.endsWith(pemFooter)) pemContents = pemContents.substring(0, pemContents.length - pemFooter.length);

      pemContents = pemContents.replace(/\s+/g, ""); // إزالة كل المسافات والأسطر
      // --------------------------

      try {
        const binaryDer = Uint8Array.from(atob(pemContents), c => c.charCodeAt(0));
        const cryptoKey = await crypto.subtle.importKey(
          "pkcs8",
          binaryDer,
          { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
          true,
          ["sign"]
        );

        // 2. إنشاء JWT لطلب التوكن من جوجل
        const now = Math.floor(Date.now() / 1000)
        const payload = {
          iss: clientEmail,
          sub: clientEmail,
          aud: "https://oauth2.googleapis.com/token",
          iat: now,
          exp: now + 3600,
          scope: "https://www.googleapis.com/auth/cloud-platform",
        }

        const jwt = await create({ alg: "RS256", typ: "JWT" }, payload, cryptoKey)

        // 3. الحصول على Access Token
        const tokenRes = await fetch("https://oauth2.googleapis.com/token", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: new URLSearchParams({ grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer", assertion: jwt }),
        })
        const { access_token } = await tokenRes.json()

        // 4. إرسال الإشعار لـ Firebase
        const fcmRes = await fetch(`https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${access_token}`,
          },
          body: JSON.stringify({
            message: {
              token: profile.fcm_token,
              notification: { title: 'رسالة جديدة', body: record.content },
            },
          }),
        })

        const result = await fcmRes.json()
        console.log('✅ نتيجة Firebase:', result)

      } catch (err) {
        console.error('❌ خطأ في التشفير أو الإرسال:', err.message)
      }
    }
  }

  return new Response(JSON.stringify({ ok: true }), { headers: { 'Content-Type': 'application/json' } })
})