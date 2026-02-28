-- ═══════════════════════════════════════════════════════════════
-- PRESTILON — Manuāli pievienot subscription lietotājam
-- Palaist: Supabase Dashboard → SQL Editor → New query
-- ═══════════════════════════════════════════════════════════════

-- ── SOLIS 1: Atrast lietotāja UUID pēc e-pasta ───────────────
-- Palaid šo vispirms, lai iegūtu user_id (uuid):

SELECT id, email, created_at
FROM auth.users
WHERE email = 'IERAKSTI_SAVA_EMAIL_ŠEIT@example.com';

-- ── SOLIS 2: Pievienot / atjaunot subscription ───────────────
-- Aizvieto 'USER_UUID_ŠEIT' ar id no iepriekšējā soļa
-- Aizvieto plānu pēc vajadzības:
--   plan = 'starter'       → Basic  (€4.99/mo)
--   plan = 'professional'  → Pro    (€139.99/mo)
--   plan = 'enterprise'    → Annual (€1499.99/yr)

INSERT INTO public.subscriptions (
  user_id,
  plan,
  status,
  printer_limit,
  valid_until,
  created_at,
  updated_at
)
VALUES (
  'USER_UUID_ŠEIT',          -- ← aizvieto ar īsto uuid no SOĻA 1
  'professional',             -- ← plāns: starter / professional / enterprise
  'active',                   -- ← statuss: active / trial / expired
  50,                         -- ← printera limits (max 50)
  NOW() + INTERVAL '1 year', -- ← derīguma termiņš (1 gads no šodien)
  NOW(),
  NOW()
)
ON CONFLICT (user_id)
DO UPDATE SET
  plan          = EXCLUDED.plan,
  status        = EXCLUDED.status,
  printer_limit = EXCLUDED.printer_limit,
  valid_until   = EXCLUDED.valid_until,
  updated_at    = NOW();

-- ── SOLIS 3: Pārbaudīt vai ieraksts ir izveidots ─────────────
SELECT
  s.user_id,
  p.email,
  s.plan,
  s.status,
  s.printer_limit,
  s.valid_until,
  s.created_at
FROM public.subscriptions s
LEFT JOIN auth.users p ON p.id = s.user_id
WHERE p.email = 'IERAKSTI_SAVA_EMAIL_ŠEIT@example.com';
