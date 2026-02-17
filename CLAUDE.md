# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Dev Commands

```bash
npm run dev          # Start dev server (http://localhost:3000)
npm run build        # Production build
npm run start        # Start production server
npm run lint         # Run ESLint (eslint 9, flat config)
```

## Architecture

Next.js 16 admin dashboard using App Router (`src/app/`), TypeScript, Tailwind CSS v4, and shadcn/ui components.

### Authentication

- **NextAuth v5 (beta)** with credentials provider (`src/lib/auth.ts`)
- JWT session strategy, no database sessions
- Middleware (`src/middleware.ts`) protects all `/dashboard/*` routes — unauthenticated users redirect to `/login`
- Auth API routes handled by catch-all at `src/app/api/auth/[...nextauth]/route.ts`
- Login page is a client component using `signIn()` from `next-auth/react`
- Dashboard page is a server component using `auth()` to read the session

### Database

- MongoDB via native driver (`src/lib/mongodb.ts`) — singleton pattern with global cache in dev to survive hot-reloads
- Single collection: `users` (fields: name, email, password as bcrypt hash, createdAt)
- Seed endpoint: `GET /api/seed` creates default admin user (`admin@example.com` / `admin123`)
- Connection string in `MONGODB_URI` env var (defaults to `mongodb://localhost:27017/admin-dashboard`)

### UI Components

- shadcn/ui with `new-york` style, configured in `components.json`
- Installed components in `src/components/ui/`: button, card, input, label, separator, sheet, sidebar, skeleton, tooltip
- Add new components: `npx shadcn@latest add <component-name>`
- Tailwind v4 uses CSS-only config (no `tailwind.config.js`) — theme variables in `src/app/globals.css` using oklch color space
- Path alias: `@/*` maps to `src/*`

### Key Patterns

- **Providers wrapper** (`src/components/providers.tsx`): SessionProvider + TooltipProvider, wraps entire app in root layout
- **Server vs Client components**: Pages default to server components; login form and sidebar are client components (`"use client"`)
- **Route protection flow**: `/` checks session → redirects to `/dashboard` (authenticated) or `/login` (unauthenticated)

## Environment Variables

Required in `.env.local`:
- `MONGODB_URI` — MongoDB connection string
- `AUTH_SECRET` — NextAuth secret (min 32 chars)
