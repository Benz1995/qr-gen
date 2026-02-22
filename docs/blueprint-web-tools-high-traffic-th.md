# Blueprint: โปรเจกต์เว็บ Tool ง่าย ๆ เรียกคนใช้เยอะ ๆ

## เป้าหมาย
สร้างเว็บที่มีเครื่องมือใช้ง่าย โหลดเร็ว ตอบโจทย์ค้นหาเฉพาะทาง แล้วโตด้วย SEO จนเกิดทราฟฟิกจำนวนมาก ก่อน monetize ด้วย Ads และมีระบบสมาชิกที่แยกสิทธิ์ชัดเจนระหว่างผู้ใช้ทั่วไปกับผู้ดูแลระบบ

---

## 1) แนวคิด Product

### หลักการเลือก Tool
เลือก Tool ที่มี 3 อย่างพร้อมกัน:
1. **คนค้นหาบ่อย** (เช่น “แปลงไฟล์”, “คำนวณ”, “สร้าง QR”, “ย่อรูป”)
2. **ใช้จบในหน้าเดียว** (fast utility)
3. **ทำซ้ำได้หลาย intent** (แตกหน้า SEO ได้)

### ชุด Tool เริ่มต้น (MVP)
- QR Generator
- PromptPay QR Generator
- Wi-Fi QR Generator
- Image Resize / Compress
- Text Case Converter
- JSON Formatter

> เริ่ม 3–6 tools ก่อน แล้วค่อยขยายเป็น network ของหน้า utility

---

## 2) โครงเว็บที่โตทราฟฟิกได้

- `/` Home รวมเครื่องมือทั้งหมด + หมวดหมู่
- `/tools/[slug]` หน้า Tool รายตัว
- `/category/[slug]` รวม Tool ตามหมวด
- `/blog/[slug]` บทความแก้ปัญหา long-tail
- `/dashboard` สมาชิกดูรายการที่ตัวเองเคยสร้างทั้งหมด
- `/dashboard/item/[id]` ดูรายละเอียด/แก้ชื่อ/ลบ รายการของตัวเอง
- `/admin` แดชบอร์ดผู้ดูแลระบบ (admin only)
- `/auth/login` สมัคร/ล็อกอิน
- `/privacy` `/terms` `/about`

---

## 3) การแยกระบบสิทธิ์ (สำคัญ)

### ผู้ใช้ทั่วไป (member)
- เข้าได้เฉพาะ `/dashboard` ของตัวเอง
- เห็นเฉพาะข้อมูลที่ `owner_user_id = ผู้ใช้คนนั้น`
- ดูรายการที่เคยสร้างทั้งหมด (เช่น QR ที่ generate, ไฟล์ที่แปลง)
- ลบ/แก้ชื่อได้เฉพาะของตัวเอง

### ผู้ดูแลระบบ (admin)
- เข้า `/admin` ได้เท่านั้น
- เห็นข้อมูลรวมระบบ, moderation, metrics
- **ห้ามใช้หน้า member dashboard แทนผู้ใช้**
- การเข้าถึงข้อมูลผู้ใช้รายคนทำได้เฉพาะหน้าจัดการ admin พร้อม audit log

### กฎบังคับระดับ backend
- ตรวจ role ทุก endpoint ฝั่ง server
- Query ต้องมีเงื่อนไข owner เสมอใน member APIs
- Admin APIs ต้อง require `role = admin`
- ห้ามเช็คสิทธิ์แค่ฝั่ง frontend

---

## 4) Monetization (ไม่ซับซ้อน)

### ระยะเริ่มต้น
- ฟรีทั้งหมด + AdSense
- วาง ads เฉพาะตำแหน่งที่ไม่ขัด workflow (max 2–3 จุด/หน้า)

### ระยะต่อไป
- สมาชิกฟรี: เก็บประวัติ/รายการโปรด/รายการที่เคยสร้าง
- Optional Pro (ทีหลัง): ปิดโฆษณา + batch processing + export เพิ่ม

---

## 5) SEO System ที่ทำให้โต

### Page template ที่ต้องมีทุก Tool
- Title/H1 เฉพาะ intent
- Description + วิธีใช้ 3 ขั้น
- FAQ schema
- Internal links ไป tool ที่เกี่ยวข้อง
- ตัวอย่าง input/output สำเร็จรูป

### คีย์เวิร์ด strategy
- Head term: “QR Generator”, “JSON Formatter”
- Mid-tail: “สร้าง QR promptpay ฟรี”, “json formatter online”
- Long-tail: “สร้าง qr wifi ไม่ต้องแอพ”, “แปลง json ให้อ่านง่าย”

### เป้าเนื้อหา 30 วันแรก
- หน้า Tool 10 หน้า
- หน้า Blog 20 บทความ (problem-solution)

---

## 6) User Retention (ดึงกลับมาใช้ซ้ำ)

- Sign in ฟรีเพื่อบันทึกการใช้งานล่าสุด
- Favorite tools
- Recently used
- ประวัติรายการที่เคยสร้างทั้งหมด
- แชร์ลิงก์ผลลัพธ์ได้ (ถ้าทำได้)

KPI retention:
- Returning users 7 วัน
- Member signup rate
- Avg tools used/session
- Saved items / member

---

## 7) Stack แนะนำ (ทำไว)

- Frontend: Next.js + Tailwind
- API: Next.js Route Handlers
- DB: Postgres (Supabase ได้)
- Auth: Supabase Auth / NextAuth
- Analytics: GA4 + first-party events
- Ads: AdSense

---

## 8) API แยก member/admin

### Member APIs
- `POST /api/tools/run` รัน tool และบันทึกประวัติของผู้ใช้
- `GET /api/dashboard/items` ดึงรายการที่ผู้ใช้คนนี้เคยสร้าง
- `GET /api/dashboard/items/:id` ดูรายละเอียดรายการของตัวเอง
- `PATCH /api/dashboard/items/:id` แก้ชื่อ/tag ของตัวเอง
- `DELETE /api/dashboard/items/:id` ลบรายการของตัวเอง

### Admin APIs
- `GET /api/admin/overview` ภาพรวม usage + revenue
- `GET /api/admin/users` รายชื่อผู้ใช้และสถิติ
- `GET /api/admin/tools` health ของแต่ละ tool

ทุก `/api/admin/*` ต้องเช็ค role = admin และบันทึก audit log

---

## 9) Event Tracking ที่ควรมี

Event หลัก:
- `page_view`
- `tool_run`
- `result_copy`
- `result_download`
- `member_signup`
- `favorite_tool`
- `dashboard_view`
- `admin_view`
- `ad_impression`
- `ad_click`

Dimension หลัก:
- `tool_slug`, `page_path`, `device_type`, `country_code`, `referrer_host`, `utm_*`

---

## 10) แผนลงมือ 7 วัน (ปล่อยใช้จริง)

### Day 1–2
- ตั้งโครงเว็บ + Home + Tool page template
- ทำ tool แรก 3 ตัว

### Day 3–4
- ทำ auth + role (member/admin)
- ทำ member dashboard ให้เห็นรายการที่ตนเองสร้างทั้งหมด

### Day 5
- ทำ admin dashboard (overview only) + audit log เบื้องต้น
- ติด GA4 + event tracking + AdSense

### Day 6
- ลงบทความ SEO ชุดแรก 10 บทความ

### Day 7
- ปรับ Core Web Vitals + submit sitemap + indexing
- ทดสอบสิทธิ์ member/admin ครบทุก endpoint

---

## 11) KPI 60 วันแรก

- 50,000 sessions/เดือน
- Returning users > 18%
- Signup rate > 3%
- Avg tools/session > 1.4
- Page RPM 35–120 บาท

ถ้าได้ตามนี้ ให้ขยาย tool cluster ต่อทันที

## 12) Security Hardening (ป้องกันการโดนแฮก)

- ใช้ server-side RBAC เท่านั้น ห้ามพึ่ง frontend check
- member เห็นข้อมูลตัวเองเท่านั้น (`owner_user_id = current_user`)
- admin ต้องใช้ MFA และทุกการกระทำต้องมี `admin_audit_logs`
- เปิด rate limit: login/signup/tool-run/admin endpoints
- เปิด RLS + ownership policies ที่ระดับฐานข้อมูล
- ใช้ HTTP-only secure cookies + CSRF protection
- ใส่ security headers: CSP, HSTS, X-Frame-Options, X-Content-Type-Options
- sanitize input/output และใช้ prepared statements ป้องกัน SQLi/XSS
- มี monitoring + alert สำหรับ auth fail spike และ admin anomaly

รายละเอียดเช็กลิสต์ดูที่ `docs/security-hardening-th.md`

