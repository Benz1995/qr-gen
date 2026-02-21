-- Schema for free QR generator monetized by ads, with member accounts to save QR

create table if not exists app_users (
  id uuid primary key,
  email text unique not null,
  display_name text,
  auth_provider text not null default 'magic_link',
  created_at timestamptz not null default now()
);

create table if not exists user_qr_codes (
  id uuid primary key,
  user_id uuid not null references app_users(id) on delete cascade,
  title text,
  qr_type text not null check (
    qr_type in ('url', 'text', 'wifi', 'line_oa', 'promptpay', 'google_review')
  ),
  payload_json jsonb not null,
  style_json jsonb,
  tags text[] not null default '{}',
  is_archived boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists traffic_events (
  id bigserial primary key,
  event_name text not null check (
    event_name in (
      'page_view',
      'qr_generate',
      'qr_download',
      'member_signup',
      'member_login',
      'qr_save',
      'dashboard_view',
      'ad_impression',
      'ad_click'
    )
  ),
  occurred_at timestamptz not null default now(),
  session_id text,
  user_id uuid references app_users(id) on delete set null,
  page_path text not null,
  template_type text,
  country_code text,
  device_type text,
  referrer_host text,
  utm_source text,
  utm_medium text,
  utm_campaign text,
  metadata jsonb
);

create table if not exists ad_daily_metrics (
  metric_date date not null,
  page_path text not null,
  impressions bigint not null default 0,
  clicks bigint not null default 0,
  estimated_revenue_thb numeric(12,2) not null default 0,
  primary key (metric_date, page_path)
);

create index if not exists idx_user_qr_codes_user_created on user_qr_codes(user_id, created_at desc);
create index if not exists idx_user_qr_codes_user_updated on user_qr_codes(user_id, updated_at desc);
create index if not exists idx_traffic_events_occurred_at on traffic_events(occurred_at desc);
create index if not exists idx_traffic_events_event_page on traffic_events(event_name, page_path, occurred_at desc);
create index if not exists idx_traffic_events_user_event on traffic_events(user_id, event_name, occurred_at desc);

-- Optional materialized view for weekly KPI
create materialized view if not exists weekly_kpi as
select
  date_trunc('week', occurred_at)::date as week_start,
  count(*) filter (where event_name = 'page_view') as page_views,
  count(*) filter (where event_name = 'qr_generate') as qr_generates,
  count(*) filter (where event_name = 'qr_download') as qr_downloads,
  count(*) filter (where event_name = 'member_signup') as member_signups,
  count(*) filter (where event_name = 'qr_save') as qr_saves,
  count(*) filter (where event_name = 'ad_impression') as ad_impressions,
  count(*) filter (where event_name = 'ad_click') as ad_clicks
from traffic_events
group by 1;
