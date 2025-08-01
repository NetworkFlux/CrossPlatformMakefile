# 🧱 CPM – Cross-Platform Makefile

> A robust, portable, and extensible Makefile that helps you build **C projects for Windows, Linux, and macOS** — hassle-free.

## 🌍 Why This Project?

If you’ve ever written C code that works flawlessly on one system — only to have it break completely when switching platforms — you’re not alone.

I often work across multiple platforms, and porting C projects eats up way too much of my time and energy. Unless you’re a true CodeChad™, it’s hard to keep track of all the differences in compilers, flags, file formats, and paths between Windows, Linux, and macOS.

Yes, I know tools like CMake exist. They’re powerful, widely used, and support cross-platform development out of the box — but they’re also **opaque**. They abstract away too much of what’s actually going on during compilation and linking. They “just work”, but they don’t **teach**.

That’s why I created **CPM**.

## 🧰 Why Make?

Make is deceptively simple — at the end of the day, it just runs shell commands. But that’s exactly what makes it powerful for learning.

Writing a Makefile means:
- You have to **understand the full compilation and linking process**.
- You try it out manually first, then automate it.
- You stay close to the system — and **you learn more**.

Sure, it’s a bit more effort upfront, but it pays off. You gain a clearer mental model of how C is compiled and linked on each platform. And you end up with something customizable and transparent — no hidden magic.

This project aims not just to give you a working Makefile — but also to **guide you through how it works**, so you can confidently modify it, extend it, and truly own your build system.
