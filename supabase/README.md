# Supabase Backend Setup Guide

## Quick Setup

### 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up
2. Create a new project named "StyleAI"
3. Copy the project URL and anon key from Settings > API

### 2. Set Environment Variables

Create a `.env.local` file:

```bash
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
OPENAI_API_KEY=sk-your-openai-key
```

### 3. Run Database Migration

In Supabase Dashboard:
1. Go to SQL Editor
2. Copy and paste the contents of `supabase/migrations/001_initial_schema.sql`
3. Click Run

Or use Supabase CLI:

```bash
npm install -g supabase
supabase login
supabase link --project-ref your-project-ref
supabase db push
```

### 4. Deploy Edge Functions

```bash
supabase functions deploy analyze-image
supabase functions deploy recommend-outfit
```

### 5. Set Edge Function Secrets

```bash
supabase secrets set OPENAI_API_KEY=sk-your-openai-key
```

## API Endpoints

### Analyze Image
```bash
POST /functions/v1/analyze-image
Content-Type: application/json
Authorization: Bearer <anon-key>

{
  "imageBase64": "base64-encoded-image-data"
}
```

### Recommend Outfit
```bash
POST /functions/v1/recommend-outfit
Content-Type: application/json
Authorization: Bearer <anon-key>

{
  "occasion": "通勤",
  "style": "简约",
  "weather": { "temp": 22, "condition": "晴" },
  "wardrobeItems": [
    { "id": "uuid", "name": "白T恤", "category": "上衣", "color": "白色" }
  ]
}
```

## Storage Bucket

Create a storage bucket named `clothing-images`:
1. Go to Storage in Supabase Dashboard
2. Create new bucket: `clothing-images`
3. Set as public bucket
4. Add RLS policies for authenticated users
