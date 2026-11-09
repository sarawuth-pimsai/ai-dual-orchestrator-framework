# คู่มือใช้งาน AI Dual-Orchestrator Framework

คู่มือนี้อธิบายการติดตั้งและใช้งาน framework กับโปรเจกต์ของคุณ โดยใช้ release `v1.4.0` เป็นตัวอย่าง Framework เป็นชุดคำแนะนำและเอกสาร ไม่ใช่ระบบที่เปิด agent หรือส่งงานระหว่าง GPT กับ Claude ให้อัตโนมัติ

## 1. บทบาทและลำดับการทำงาน

| บทบาท | หน้าที่ |
| --- | --- |
| Founder (คุณ) | ให้ requirement กับ Tech PO และอนุมัติ product scope, การพัฒนา, deployment และ release รวมถึงการตัดสินใจทางธุรกิจที่ยังเปิดอยู่ |
| Tech Orchestrator / PO (Claude) | รับ requirement จากคุณ ดูแลเอกสาร requirement และ acceptance criteria ประสานงานออกแบบ พัฒนา QA และ security ภายใต้ขอบเขตที่อนุมัติ |
| Business Orchestrator (GPT) | รับ handoff จาก Tech เมื่อจำเป็นต้องใช้ UX/UI, กฎหมาย, การเงิน, การตลาด หรือความเชี่ยวชาญทางธุรกิจอื่น |
| PM | รวมแผน ติดตาม dependencies, ความเสี่ยง และสถานะจากหลักฐาน โดยไม่อนุมัติหรือสั่งงานแทน orchestrator |

ภาพรวม: **Founder → Tech/PO → Business เมื่อจำเป็น → Tech/PO → Founder ตัดสินใจ → Tech ดำเนินงานตามที่อนุมัติ**

แต่ละโปรเจกต์ต้องมี repository และแหล่งข้อมูลหลักของตัวเอง เช่น board และบันทึกการตัดสินใจ อย่านำข้อมูลของอีกโปรเจกต์มาใช้แทน และอย่าเก็บข้อมูลลับของโปรเจกต์ไว้ใน framework repository

## 2. ติดตั้งในโปรเจกต์ใหม่

ต้องมี Bash, Git, `curl`, `unzip`, `shasum` หรือ `sha256sum` และเครื่องมือ Unix พื้นฐาน ตัวอย่างนี้ใช้ macOS/Linux และต้องเข้าถึง GitHub ได้ `--version` ใช้ Git ตรวจ tag แม้จะระบุ ZIP ในเครื่องแล้ว

ตรวจสอบว่าอยู่ใน **โปรเจกต์ที่ต้องการติดตั้ง** และสำรองงานหรือ commit งานเดิมก่อน หากโปรเจกต์มี `AGENTS.md`, `CLAUDE.md` หรือไฟล์ managed อยู่แล้ว `init` จะปฏิเสธเมื่อเนื้อหาไม่ตรงกัน ให้ตรวจและจัดการด้วยตนเองก่อน ไม่เขียนทับโดยอัตโนมัติ

### รุ่นปัจจุบันและการเตรียมใช้คำสั่งใหม่

release `v1.4.0` ที่เผยแพร่แล้ว **ยังต้องใช้ trust file** เมื่อละ `--sha256` และยังไม่มี `ai update` การเปลี่ยนแปลงให้ดาวน์โหลด checksum อัตโนมัติอยู่ใน CLI รุ่นพัฒนา ยังต้องออก release ใหม่ก่อนจึงจะดาวน์โหลดจากหน้า Releases ได้

ใน CLI รุ่นใหม่นั้น หลังติดตั้ง CLI ที่ตรวจสอบแล้วลงใน `PATH` จะใช้คำสั่ง:

```sh
ai --help
ai --version
ai init project
ai project update
ai update
```

`ai update` เปลี่ยนเฉพาะไฟล์ CLI และถามก่อนเขียน ส่วน `ai project update` เปลี่ยนเฉพาะโปรเจกต์ปัจจุบัน แสดง diff และถามก่อนเขียน ทั้งสองไม่ได้อนุญาตหรือสั่งให้อีกส่วนอัปเดตโดยอัตโนมัติ ถ้าติดตั้ง CLI ผ่าน package manager ให้ใช้ package manager อัปเดตแทน

CLI รุ่นใหม่ดาวน์โหลด ZIP และ `SHA256SUMS` ของ release จาก GitHub แล้วตรวจ checksum ให้เอง ข้อมูลจากแหล่งเดียวกันช่วยตรวจความตรงกันของไฟล์ แต่ไม่ยืนยันแหล่งที่มาอย่างอิสระ หากต้องการตรวจสอบแยก ให้ใช้ `--sha256` ที่ได้รับจากช่องทางที่เชื่อถือได้ สำหรับการใช้งาน offline ให้ระบุ commit เต็ม, checksum และ `--archive` ของ ZIP ที่ตรวจสอบแล้ว

### ตัวอย่างสำหรับ CLI v1.4.0 ที่เผยแพร่แล้ว

ดาวน์โหลดไฟล์ CLI และ ZIP จาก [release v1.4.0](https://github.com/sarawuth-pimsai/ai-dual-orchestrator-framework/releases/tag/v1.4.0) แล้วตรวจ checksum จากแหล่งที่เชื่อถือได้ ค่าของ CLI คือ `71f944a94f533a2521879d8f44da5ae8de3e6cca08fab6d5923e183f10f127da` และ ZIP คือ `d86da42febba05390ea6c408d58f61a3ccbf69e907e5376902502d6dbac2f987` ตรวจสอบไฟล์เดิมก่อนคัดลอก CLI ลง `PATH` เพราะการคัดลอกอาจเขียนทับไฟล์ที่มีอยู่

หากใช้ CLI `v1.4.0` แบบไม่มี `--sha256` ต้องเพิ่มบรรทัดที่ตรวจสอบอย่างอิสระแล้วใน `${XDG_CONFIG_HOME:-$HOME/.config}/ai-framework/trusted-releases` ก่อน:

```text
v1.4.0 7d060f675edf8146647718f93c55db59a8e30821 d86da42febba05390ea6c408d58f61a3ccbf69e907e5376902502d6dbac2f987
```

หรือใช้ CLI v1.4.0 ระบุ checksum และ ZIP โดยตรง:

```sh
ai init project . --version v1.4.0 \
  --sha256 d86da42febba05390ea6c408d58f61a3ccbf69e907e5376902502d6dbac2f987 \
  --archive /path/to/framework-v1.4.0.zip
```

`.` คือโปรเจกต์ปัจจุบัน คำสั่งสร้าง `AGENTS.md`, `CLAUDE.md` และ `.ai-framework/` ให้ตรวจผลและ commit ตามความเหมาะสม โดยเก็บบริบทและการตัดสินใจในพื้นที่ที่โปรเจกต์ดูแลเอง

### ตรวจเวอร์ชัน CLI และ framework

`ai --version` หรือ `ai version` แสดงเวอร์ชัน CLI ตั้งแต่ v1.3.0 ส่วน `cat .ai-framework/VERSION` ที่รันจากโฟลเดอร์โปรเจกต์แสดง commit ของ framework ที่ติดตั้ง ซึ่งเป็นคนละข้อมูลกัน

## 3. เตรียมข้อมูลโปรเจกต์

คัดลอก `.ai-framework/framework/templates/PROJECT_BOOTSTRAP.md` ไปยังตำแหน่งที่โปรเจกต์ดูแลเอง แล้วระบุชื่อ repository, board หรือ `NONE`, แหล่งเก็บ requirement และ decision records, เป้าหมาย, สิทธิ์เข้าถึง และการอนุมัติที่มีอยู่ ระบุสิ่งที่ยังไม่ทราบ แทนการคาดเดา

เปิดสิทธิ์ที่จำเป็นให้แต่ละ session หรือส่งสำเนาข้อมูลพร้อมวันที่ หาก session ตรวจ issue, PR หรือ board ไม่ได้ ให้รายงานว่า **NOT VERIFIED** ไม่สมมติว่าเข้าถึงได้

## 4. เริ่ม Tech และส่ง requirement

เปิดโปรเจกต์ใน Claude Code และเริ่ม session ด้วยข้อความตัวอย่าง:

```text
เริ่มบทบาท Tech Orchestrator ตาม AGENTS.md และ
.ai-framework/framework/roles/TECH_ORCHESTRATOR.md
ให้ PO รับ requirement จากผมโดยตรง ตรวจสอบ repository, board,
decisions และสถานะล่าสุดก่อน ถ้าไม่มีสิทธิ์ตรวจให้ระบุชัดเจน
ช่วยรวบรวม requirement และ acceptance criteria และเตรียม handoff
ไป Business เมื่อต้องใช้ UX/UI กฎหมาย หรือข้อมูลธุรกิจอื่น
ยังไม่เริ่ม implementation จนกว่าผมจะอนุมัติขอบเขต
```

จากนั้นบอกเป้าหมาย ปัญหาของผู้ใช้ และข้อจำกัดที่ทราบ PO จะตรวจข้อมูล ถามสิ่งที่จำเป็น และเสนอ requirement กับ acceptance criteria โดยแยก **PROPOSED**, **APPROVED**, **OPEN** และ **SUPERSEDED** ให้ชัดเจน การเตรียมแผนหรือ handoff ไม่ถือว่าได้รับอนุมัติให้พัฒนา

## 5. ใช้ Business และส่ง handoff

เปิด GPT session แยกสำหรับ Business ให้เข้าถึง framework และข้อมูลโปรเจกต์ที่จำเป็น แล้วใช้ prompt:

```text
เริ่มบทบาท Business Orchestrator ตาม AGENTS.md และ
.ai-framework/framework/roles/BUSINESS_ORCHESTRATOR.md
ตรวจสอบ source of truth และรับ handoff จาก Tech PO
รายงานสถานะ หลักฐาน blockers เจ้าของงานถัดไป และสิ่งที่ต้องการจาก Founder
```

เมื่อ Tech ขอความช่วยเหลือ ให้คัดลอก prompt ในหัวข้อ **Handoff to send** ไปส่ง Business พร้อมเอกสารหรือสิทธิ์ที่จำเป็น ผู้รับต้องตอบรับจริงก่อนถือว่ารับงาน จากนั้นคัดลอกผลและหลักฐานกลับให้ Tech PO ตรวจและรวมใน contract การโพสต์ issue หรือ comment อย่างเดียวไม่ได้เรียก agent อีกฝั่ง

Handoff ฉบับเต็มใช้ `.ai-framework/framework/templates/HANDOFF.md` ระบุผู้ส่ง/ผู้รับ บริบท ผลงาน เกณฑ์ยอมรับ dependencies, approval gate และ next owner โดยใช้ issue เดิมเมื่อเหมาะสม ไม่สร้างซ้ำโดยไม่จำเป็น

## 6. อนุมัติ พัฒนา และจัดการ PR

คุณพิจารณาอนุมัติ product scope และการตัดสินใจที่ยังเปิดอยู่ แล้วระบุการอนุญาต implementation สำหรับขอบเขตที่ต้องการอย่างชัดเจน การอนุมัติ design ไม่เท่ากับอนุมัติ implementation Tech จัดทำแผน task และหลักฐาน review/test ตามความเสี่ยง

- PR ที่ยังไม่ผ่านเงื่อนไข merge หรือยังตรวจสอบไม่ได้อยู่ใน **Draft**
- เมื่อ review, checks, dependencies และการอนุมัติที่เกี่ยวข้องผ่านครบ ให้เป็น **Ready for review** บน GitHub และรายงาน **READY TO MERGE** พร้อมหลักฐาน สถานะ Ready ไม่ได้หมายความว่า merge แล้ว
- หาก review หรือ check ที่จำเป็นทำไม่ได้ขณะเป็น Draft ให้รายงานเป็น blocker และขอการตัดสินใจเรื่อง workflow โดยไม่ข้ามข้อกำหนด
- หากไม่มีสิทธิ์เปลี่ยนสถานะ ให้รายงานสถานะจริง ความต่างจากสถานะที่ควรเป็น และผู้รับผิดชอบ

หลัง QA และหลักฐานที่จำเป็นครบ Tech เสนอผลและแผน rollback เพื่อให้ Founder ตัดสินใจ release ตาม gate ใน `GOVERNANCE.md`

## 7. รายงานและติดตามงาน

GPT, Claude และ PM ใช้ `.ai-framework/framework/templates/STATUS_REPORT.md` เป็นรูปแบบร่วม โดยรายงานสถานะ หลักฐาน การตรวจรับ/อนุมัติ blockers, next owner, handoff ที่ส่งได้ PR ที่ต้องดำเนินการ และสิ่งที่ต้องการจาก Founder เท่าที่เกี่ยวข้อง คำถามง่าย ๆ ตอบตรงได้โดยไม่ต้องกรอกทุกหัวข้อ

ตัวอย่าง prompt สำหรับสถานะ:

```text
tech status — ตรวจหลักฐานล่าสุด แสดง PR, handoff, blockers และ Founder action
business status — สรุปงานที่รับจาก Tech และผลที่พร้อมส่งกลับ
pm status — รวม milestone, dependencies, critical path และความเสี่ยงจากหลักฐาน
```

ข้อความเหล่านี้เป็น **natural-language prompts** ไม่ใช่คำสั่ง CLI ที่ติดตั้งไว้ PM ต้องมี session และสิทธิ์เข้าถึงจริง ไม่ได้ติดตามงานเบื้องหลังโดยอัตโนมัติ

## 8. อัปเดตหรือย้อนเวอร์ชัน

ใน CLI รุ่นพัฒนา ใช้ `ai update` เพื่ออัปเดต CLI และใช้ `ai project update` จากโฟลเดอร์โปรเจกต์เพื่ออัปเดต framework แต่ละคำสั่งแสดงสิ่งที่จะเปลี่ยนและถามให้พิมพ์ `yes` ก่อนเขียน ใน CLI v1.4.0 ที่เผยแพร่แล้ว `ai update` ยังไม่มี และการอัปเดตโปรเจกต์ยังต้องตั้ง trust file หรือระบุ `--sha256` ด้วยตนเอง

ตรวจ diff ก่อนยืนยัน การย้อน framework ใช้ `ai project update --commit FULL_COMMIT --sha256 TRUSTED_SHA256 --archive /path/to/old.zip` เก็บ ZIP และ checksum เดิมไว้ สำรองโปรเจกต์ก่อนอัปเดต: write error ปกติมีการพยายาม rollback แต่การหยุดกลางคันหรือเครื่องขัดข้องอาจต้องกู้เอง สำหรับ CLI ให้เก็บสำเนารุ่นก่อนที่ตรวจสอบแล้วไว้เพื่อกู้ด้วยตนเองหากจำเป็น

หากพบ `managed files were modified` ให้ตรวจและจัดการไฟล์ที่เปลี่ยนก่อน ระบบไม่เขียนทับโดยอัตโนมัติ หากพบ SHA mismatch ให้ตรวจ ZIP และ checksum ใหม่ Python CLI รุ่นเดิมใช้ schema 1 และอัปเดตข้ามกับ shell schema 2 ไม่ได้ ต้องสำรองและย้ายด้วยตนเอง ดู [README](README.md) และ [ARCHITECTURE_BOOTSTRAP.md](ARCHITECTURE_BOOTSTRAP.md)
