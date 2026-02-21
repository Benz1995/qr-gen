# Blueprint: QR Gen ฟรีล้วน + ติด Ads + มีสมาชิกเก็บ QR

## เลือกแนวทาง
เลือกโมเดล **Free + Ads + Member Accounts**: ผู้ใช้ทั่วไปใช้ฟรีได้ทันที, เว็บทำรายได้จาก ads, และคนที่อยากเก็บ QR ของตัวเองสมัครสมาชิก (ฟรี) เพื่อใช้งานต่อเนื่องข้ามอุปกรณ์

---

## 1) Product Scope (MVP ฟรี 100% + สมัครสมาชิก)

### Guest Mode (ไม่ต้องล็อกอิน)
- สร้าง QR URL / Text / Wi-Fi / LINE OA / PromptPay / Google Review
- ปรับสี, โลโก้, ขนาด, error correction
- ดาวน์โหลด PNG/SVG
- ใช้งานได้ทันที ไม่มี paywall

### Member Mode (สมัครฟรี)
- สมัคร/ล็อกอินด้วย email magic link หรือ Google
- บันทึก QR ของตัวเองลงบัญชี
- ดูรายการ “QR ของฉัน”
- แก้ชื่อ/จัดหมวด/ลบ QR ได้
- ซิงก์ข้อมูลข้ามอุปกรณ์

### Revenue Layer (Ads)
- ติดโฆษณาในหน้า generator, template, blog, และ dashboard free tier
- จำกัด density (max 2–3 ad slots/page) เพื่อไม่ทำ UX แย่
- หลีกเลี่ยง ads รบกวน workflow ตอนผู้ใช้กำลังกรอกข้อมูลสำคัญ

---

## 2) Information Architecture

- `/` หน้า Generator หลัก (ads)
- `/templates` รวมเทมเพลตพร้อมใช้ (ads)
- `/blog/[slug]` คอนเทนต์ SEO (ads)
- `/auth/login` ล็อกอิน/สมัครสมาชิกฟรี
- `/dashboard` QR ของฉัน (ต้องล็อกอิน)
- `/dashboard/qr/[id]` แก้ไข metadata QR
- `/about` `/privacy` `/terms` เพื่อผ่าน policy ads

---

## 3) Technical Stack (ทำไว ดูแลง่าย)

- **Frontend:** Next.js + Tailwind
- **Backend/API:** Next.js Route Handlers
- **Auth:** Supabase Auth หรือ NextAuth (magic link + social login)
- **DB:** Postgres / Supabase Postgres
- **QR library:** `qrcode` หรือ `qr-code-styling`
- **Analytics:** GA4 + first-party events
- **Ads:** Google AdSense (เริ่มต้น)

---

## 4) Core Flows

### A) Guest Generate Flow
1. ผู้ใช้กรอกข้อมูลและสร้าง QR
2. ดาวน์โหลดไฟล์ได้ทันที
3. แสดง CTA: “สมัครฟรีเพื่อบันทึก QR นี้ไว้แก้ไขภายหลัง”

### B) Save-to-Account Flow
1. ผู้ใช้กด “บันทึก QR”
2. ถ้ายังไม่ล็อกอินให้ไป `/auth/login`
3. กลับมาหน้าเดิมและบันทึก QR ลง `user_qr_codes`
4. redirect ไป `/dashboard` เพื่อจัดการ QR

### C) Dashboard Flow
- list / search / filter QR
- edit title + tags + payload
- delete QR
- track event เพื่อ optimize retention

---

## 5) Revenue Model & KPI

### รายได้หลัก
- Display ads (AdSense/ad network)

### KPI สำคัญ
- SEO sessions
- Guest→Member signup rate
- % สมาชิกที่บันทึก QR อย่างน้อย 1 อัน
- DAU/WAU ของ dashboard
- Ad CTR / Page RPM

### เป้าเริ่มต้น
- Signup rate > 4%
- Member with ≥1 saved QR > 45%
- Page RPM เฉลี่ย 35–120 บาท

---

## 6) SEO Plan (10 หน้าแรก)

1. สร้าง QR PromptPay ฟรี
2. สร้าง QR Wi-Fi ฟรี
3. สร้าง QR รีวิว Google ฟรี
4. สร้าง QR LINE OA ฟรี
5. สร้าง QR เมนูร้านอาหาร
6. สร้าง QR ใส่โลโก้
7. วิธีเก็บ QR ไว้แก้ไขภายหลัง
8. วิธีทำ QR สำหรับหน้าร้าน
9. วิธีพิมพ์ QR ให้สแกนง่าย
10. template QR สำหรับร้านค้าไทย

ทุกหน้าต้องมี: prefilled tool + FAQ schema + internal links

---

## 7) API/Endpoint Draft

- `POST /api/qr/generate` สร้าง QR payload
- `POST /api/qr/save` บันทึก QR ลงบัญชี (auth required)
- `GET /api/qr/my` ดึง QR ของสมาชิก
- `PATCH /api/qr/:id` แก้ไขข้อมูล QR
- `DELETE /api/qr/:id` ลบ QR
- `POST /api/events` รับ analytics events

---

## 8) 3-Day Launch Plan

### Day 1
- Generator + templates (PromptPay/Wi-Fi/LINE/Review)
- วาง ad slots 2–3 จุด
- ทำ auth หน้า login/signup

### Day 2
- Save QR เข้า account + dashboard list/edit/delete
- GA4 + first-party tracking events
- SEO pages ชุดแรก 10 หน้า

### Day 3
- ปรับ UX ของ dashboard + search/filter
- ทำ metrics พื้นฐาน (signup/save rate)
- submit sitemap + indexing

---

## 9) Next Step ต่อจากนี้

- เพิ่ม dynamic QR เฉพาะสมาชิก (ยังฟรีได้ในช่วงแรก)
- เพิ่ม export/import QR
- เปิด optional pro plan เมื่อ retention ดีพอ
