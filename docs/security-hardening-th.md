# Security Hardening Checklist (สำหรับโปรเจกต์เว็บ Tool)

## 1) Auth & Session
- ใช้ HTTP-only, Secure, SameSite=strict cookies
- บังคับ session expiry + rotate refresh token
- บังคับ re-auth สำหรับ action สำคัญฝั่ง admin
- เปิด MFA สำหรับ admin ทุกบัญชี

## 2) Authorization (RBAC)
- ทุก API ตรวจสิทธิ์ฝั่ง server เท่านั้น
- member อ่าน/แก้ได้เฉพาะ resource ที่ `owner_user_id = current_user`
- admin endpoint (`/api/admin/*`) ต้องเช็ค role=admin ทุกครั้ง
- ปิดการเข้าถึง direct object ids โดยไม่ผ่าน ownership check

## 3) Database Security
- เปิด Row Level Security (RLS)
- เขียน policy แยก member/admin อย่างชัดเจน
- ใช้ least-privilege DB roles (app_user, app_admin, migrator)
- hash/pseudonymize ข้อมูลส่วนบุคคลที่ไม่จำเป็นต้องเก็บแบบ plaintext

## 4) Input / Output Protection
- validate input ทุก endpoint (length, format, allow-list)
- sanitize output ที่แสดงกลับหน้าเว็บ (กัน XSS)
- ป้องกัน SQL injection ด้วย prepared statements เท่านั้น
- จำกัดขนาด payload และไฟล์อัปโหลด

## 5) Abuse Protection
- rate limit ตาม IP + user_id + endpoint
- bot detection เบื้องต้น (challenge/captcha เฉพาะเสี่ยง)
- cooldown ต่อ action ที่โดนยิงซ้ำได้ (signup/login/tool-run)
- anomaly alert เมื่อ error/auth fail สูงผิดปกติ

## 6) Admin Security
- แยกโดเมน/เส้นทาง admin ให้ชัดเจน
- บันทึก `admin_audit_logs` ทุก action สำคัญ
- แจ้งเตือนเมื่อมี privilege change หรือ login จาก location ใหม่
- ห้ามใช้ shared admin account

## 7) Infra & Secrets
- เก็บ secret ใน secret manager (ไม่ hardcode)
- หมุน API keys ตามรอบเวลา
- เปิด TLS ทุก environment
- เปิด security headers (CSP, HSTS, X-Frame-Options, X-Content-Type-Options)

## 8) Monitoring & Incident
- รวม log: auth, admin action, rate-limit, error
- ตั้ง alert: auth fail spike, 5xx spike, unusual admin access
- มี incident runbook และขั้นตอน revoke session/token
- backup + restore test รายเดือน
