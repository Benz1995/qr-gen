-- Schema for high-traffic web tools (free + ads + free members)

create table if not exists app_users (
  id uuid primary key,
  email text unique not null,
  display_name text,
  auth_provider text not null default 'magic_link',
  created_at timestamptz not null default now()
);

create table if not exists tools_catalog (
  slug text primary key,
  name text not null,
  category text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists user_tool_preferences (
  user_id uuid not null references app_users(id) on delete cascade,
  tool_slug text not null references tools_catalog(slug) on delete cascade,
  is_favorite boolean not null default false,
  last_used_at timestamptz,
  run_count bigint not null default 0,
  primary key (user_id, tool_slug)
);

create table if not exists traffic_events (
  id bigserial primary key,
  event_name text not null check (
    event_name in (
      'page_view',
      'tool_run',
      'result_copy',
      'result_download',
      'member_signup',
      'member_login',
      'favorite_tool',
      'ad_impression',
      'ad_click'
    )
  ),
  occurred_at timestamptz not null default now(),
  session_id text,
  user_id uuid references app_users(id) on delete set null,
  tool_slug text references tools_catalog(slug) on delete set null,
  page_path text not null,
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
  tool_slug text,
  impressions bigint not null default 0,
  clicks bigint not null default 0,
  estimated_revenue_thb numeric(12,2) not null default 0,
  primary key (metric_date, page_path)
);

create index if not exists idx_user_tool_pref_last_used on user_tool_preferences(user_id, last_used_at desc);
create index if not exists idx_traffic_events_occurred_at on traffic_events(occurred_at desc);
create index if not exists idx_traffic_events_tool_event on traffic_events(tool_slug, event_name, occurred_at desc);
create index if not exists idx_traffic_events_page_event on traffic_events(page_path, event_name, occurred_at desc);

create materialized view if not exists weekly_kpi as
select
  date_trunc('week', occurred_at)::date as week_start,
  count(*) filter (where event_name = 'page_view') as page_views,
  count(*) filter (where event_name = 'tool_run') as tool_runs,
  count(*) filter (where event_name = 'result_download') as result_downloads,
  count(*) filter (where event_name = 'member_signup') as member_signups,
  count(*) filter (where event_name = 'favorite_tool') as favorites,
  count(*) filter (where event_name = 'ad_impression') as ad_impressions,
  count(*) filter (where event_name = 'ad_click') as ad_clicks
from traffic_events
group by 1;
