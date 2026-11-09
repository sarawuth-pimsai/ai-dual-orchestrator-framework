# คู่มือใช้งาน AI Dual-Orchestrator Framework

คู่มือนี้อธิบายการติดตั้งและใช้งาน framework กับโปรเจกต์ของคุณ โดยใช้ release `v1.1.0` เป็นตัวอย่าง Framework เป็นชุดคำแนะนำและเอกสาร ไม่ใช่ระบบที่เปิด agent หรือส่งงานระหว่าง GPT กับ Claude ให้อัตโนมัติ

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

### ตั้งค่าเพื่อใช้คำสั่งสั้นจากทุกโปรเจกต์

ตัวอย่างนี้ใช้ CLI ที่รองรับคำสั่งสั้นจาก commit `3054febd0fb5f660ad2d784c2fc41303acaff70b` และติดตั้งเฉพาะ CLI ใน `~/.local/bin` ตรวจไฟล์เดิมก่อน เพราะคำสั่ง `cp` จะเขียนทับชื่อเดียวกัน ตรวจ [Releases](https://github.com/sarawuth-pimsai/ai-dual-orchestrator-framework/releases) สำหรับ CLI รุ่นเผยแพร่ล่าสุดด้วย

```sh
mkdir -p "$HOME/ai-framework-releases/cli-3054feb"
curl -fL https://raw.githubusercontent.com/sarawuth-pimsai/ai-dual-orchestrator-framework/3054febd0fb5f660ad2d784c2fc41303acaff70b/bin/ai-framework -o "$HOME/ai-framework-releases/cli-3054feb/ai-framework"
shasum -a 256 "$HOME/ai-framework-releases/cli-3054feb/ai-framework"
```

ค่า SHA-256 ของ CLI ตาม commit ตัวอย่างคือ `3a17502acf9b3c11af768373670dd9acd40649474b143c4141ebd8cfd2ec7b7f` ให้ยืนยัน commit และ hash ผ่านช่องทางที่เชื่อถือได้แยกจากแหล่งดาวน์โหลดก่อนติดตั้ง จากนั้น:

```sh
mkdir -p "$HOME/.local/bin" "${XDG_CONFIG_HOME:-$HOME/.config}/ai-framework"
cp "$HOME/ai-framework-releases/cli-3054feb/ai-framework" "$HOME/.local/bin/ai-framework"
chmod +x "$HOME/.local/bin/ai-framework"
export PATH="$HOME/.local/bin:$PATH"
```

`export` มีผลกับ shell ปัจจุบัน หากต้องการใช้ใน shell ใหม่ ให้เพิ่ม `export PATH="$HOME/.local/bin:$PATH"` ในไฟล์ตั้งค่า shell ของคุณ เช่น `~/.zshrc` แล้วเปิด shell ใหม่

เปิดไฟล์ `${XDG_CONFIG_HOME:-$HOME/.config}/ai-framework/trusted-releases` ด้วย editor และเพิ่ม **หนึ่งบรรทัดต่อหนึ่ง release** หลังตรวจสอบ tag, commit และ SHA-256 ของไฟล์ ZIP release ผ่านช่องทางที่เชื่อถือได้แยกจากแหล่งดาวน์โหลด ตัวอย่างสำหรับ `v1.1.0`:

```text
v1.1.0 3685cb76c8c2c71679ab7b809702a8799ff379ab 7fccbeff9b3e11906b2083049334485b903fc002bc29bc224002d4e9fdcbab37
```

จากนั้นใช้จากโฟลเดอร์โปรเจกต์ได้:

```sh
cd /path/to/your-project
ai-framework init project .
```

CLI จะเลือก GitHub release ล่าสุด ตรวจ commit กับ trust file และดาวน์โหลด ZIP ของ release เพื่อตรวจ checksum หาก release ล่าสุดยังไม่มีรายการที่ยืนยันแล้ว ให้ตรวจสอบและเพิ่มรายการใหม่ก่อน โดยไม่แก้โปรเจกต์โดยอัตโนมัติ การเลือก release ล่าสุดต้องใช้อินเทอร์เน็ต; สำหรับ offline ให้ใช้ `--commit`, `--sha256` และ `--archive` ดูรายละเอียดใน [README](README.md#bootstrap-cli)

### ทางเลือก: ระบุเวอร์ชันและ ZIP ด้วยตนเอง

ดาวน์โหลดไฟล์ release ไปไว้ในโฟลเดอร์แยก แล้วตรวจสอบ commit และ checksum จากช่องทางที่เชื่อถือได้แยกจากแหล่งดาวน์โหลด:

```sh
mkdir -p "$HOME/ai-framework-releases/v1.1.0"
curl -fL https://github.com/sarawuth-pimsai/ai-dual-orchestrator-framework/releases/download/v1.1.0/ai-framework -o "$HOME/ai-framework-releases/v1.1.0/ai-framework"
curl -fL https://github.com/sarawuth-pimsai/ai-dual-orchestrator-framework/releases/download/v1.1.0/framework-v1.1.0.zip -o "$HOME/ai-framework-releases/v1.1.0/framework-v1.1.0.zip"
shasum -a 256 "$HOME/ai-framework-releases/v1.1.0/ai-framework" "$HOME/ai-framework-releases/v1.1.0/framework-v1.1.0.zip"
```

ค่า SHA-256 สำหรับตัวอย่างนี้:

```text
ai-framework           607db2ca55daec2299b6900d4d1eb272ca0f0a396c9fb751952d9319d4267d10
framework-v1.1.0.zip   7fccbeff9b3e11906b2083049334485b903fc002bc29bc224002d4e9fdcbab37
```

เทียบ hash ของ CLI และ ZIP ก่อนรัน CLI ค่าที่เผยแพร่พร้อมไฟล์ช่วยตรวจความตรงกัน แต่เพียงอย่างเดียวไม่ใช่การยืนยันแหล่งที่มาอย่างอิสระ Tag สามารถถูกเปลี่ยนให้ชี้ commit อื่นได้ และการตรวจ ZIP hash ไม่ได้พิสูจน์ว่า ZIP ในเครื่องมาจาก commit ที่ระบุ

CLI จาก release `v1.1.0` ในตัวอย่างนี้ยังไม่รองรับคำสั่งสั้น จึงต้องระบุ version และ checksum:

```sh
chmod +x "$HOME/ai-framework-releases/v1.1.0/ai-framework"
cd /path/to/your-project
"$HOME/ai-framework-releases/v1.1.0/ai-framework" init project . \
  --version v1.1.0 \
  --sha256 7fccbeff9b3e11906b2083049334485b903fc002bc29bc224002d4e9fdcbab37 \
  --archive "$HOME/ai-framework-releases/v1.1.0/framework-v1.1.0.zip"
```

`.` คือโปรเจกต์ปัจจุบัน คำสั่งสร้าง `AGENTS.md`, `CLAUDE.md` และ `.ai-framework/` รวมถึง `VERSION`, `config.yaml` และ `MANIFEST` ให้ตรวจผลและ commit ไฟล์เหล่านี้ใน repository ของโปรเจกต์ตามความเหมาะสม ไฟล์บริบท การตัดสินใจ และ handoff ของโปรเจกต์ควรอยู่ในพื้นที่ที่โปรเจกต์ดูแลเอง ไม่แก้ไฟล์ managed โดยตรง

### ตรวจเวอร์ชัน CLI และ framework

CLI ตั้งแต่ `v1.3.0` รองรับ `ai --version` หรือ `ai version` เมื่อไฟล์คำสั่งชื่อ `ai` (ถ้าใช้ชื่อ `ai-framework` ให้ใช้ชื่อนั้นแทน) โดยไม่ต้องเชื่อมต่ออินเทอร์เน็ต CLI ใน release `v1.2.0` และก่อนหน้ายังไม่รองรับคำสั่งนี้

เวอร์ชัน CLI แยกจาก framework ที่ติดตั้งในโปรเจกต์ ตรวจ commit ที่โปรเจกต์ใช้อยู่ด้วย `cat .ai-framework/VERSION` จากโฟลเดอร์โปรเจกต์

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

สำหรับโปรเจกต์ที่ติดตั้งด้วย shell CLI schema 2 ให้ดาวน์โหลด CLI และ ZIP ของ release เป้าหมาย ตรวจ checksum แล้วรันจากโปรเจกต์ เช่น อัปเดตเป็น `v1.1.0`:

```sh
"$HOME/ai-framework-releases/v1.1.0/ai-framework" framework update . \
  --version v1.1.0 \
  --sha256 7fccbeff9b3e11906b2083049334485b903fc002bc29bc224002d4e9fdcbab37 \
  --archive "$HOME/ai-framework-releases/v1.1.0/framework-v1.1.0.zip"
```

ตรวจ diff แล้วพิมพ์ `yes` เพื่อยืนยัน หรือปฏิเสธเพื่อยกเลิก การย้อนเวอร์ชันใช้ `framework update` กับ tag/commit และ ZIP ของเวอร์ชันก่อนหน้า เก็บ ZIP และ checksum เดิมไว้ สำรองโปรเจกต์ก่อนอัปเดต: write error ปกติมีการพยายาม rollback แต่การหยุดกลางคันหรือเครื่องขัดข้องอาจต้องกู้เอง

หากพบ `managed files were modified` ให้ตรวจและจัดการไฟล์ที่เปลี่ยนก่อน ระบบไม่เขียนทับโดยอัตโนมัติ หากพบ SHA mismatch ให้ตรวจ ZIP และ checksum ที่เชื่อถือได้ใหม่ Python CLI รุ่นเดิมใช้ schema 1 และอัปเดตข้ามกับ shell schema 2 ไม่ได้ ต้องสำรองและย้ายด้วยตนเอง ดู [README](README.md) และ [ARCHITECTURE_BOOTSTRAP.md](ARCHITECTURE_BOOTSTRAP.md)
