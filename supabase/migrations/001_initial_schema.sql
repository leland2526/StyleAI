-- StyleAI Database Schema
-- Supabase PostgreSQL

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- User Profiles (extends Supabase Auth)
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    nickname VARCHAR(50) NOT NULL DEFAULT '用户',
    avatar_url TEXT,
    gender VARCHAR(10),
    birthday DATE,
    height_cm INTEGER,
    weight_kg INTEGER,
    body_shape VARCHAR(20),
    style_preferences TEXT[] DEFAULT '{}',
    color_preferences TEXT[] DEFAULT '{}',
    avoid_colors TEXT[] DEFAULT '{}',
    style_test_result VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Clothing Items
CREATE TABLE IF NOT EXISTS clothing_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(20) NOT NULL CHECK (category IN ('上衣', '裤子', '裙子', '外套', '配饰', '鞋', '包', '首饰', '口红')),
    sub_category VARCHAR(50),
    color VARCHAR(50) NOT NULL,
    color_hex VARCHAR(7),
    brand VARCHAR(100),
    material VARCHAR(50),
    season TEXT[] DEFAULT '{四季}' CHECK (season <@ ARRAY['春', '夏', '秋', '冬', '四季']),
    occasion TEXT[] DEFAULT '{日常}' CHECK (occasion <@ ARRAY['通勤', '约会', '面试', '运动', '逛街', '居家', '旅行', '聚会', '日常']),
    style_tags TEXT[] DEFAULT '{}',
    image_url TEXT NOT NULL,
    thumbnail_url TEXT,
    is_favorite BOOLEAN DEFAULT FALSE,
    purchase_price DECIMAL(10,2),
    purchase_date DATE,
    notes TEXT,
    ai_confidence DECIMAL(3,2),
    ai_raw_data JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Outfits
CREATE TABLE IF NOT EXISTS outfits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name VARCHAR(100),
    occasion VARCHAR(50) NOT NULL,
    style VARCHAR(50),
    season VARCHAR(20),
    weather_temp_min INTEGER,
    weather_temp_max INTEGER,
    weather_condition VARCHAR(20),
    note TEXT,
    is_favorite BOOLEAN DEFAULT FALSE,
    ai_generated BOOLEAN DEFAULT FALSE,
    ai_reasoning TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Outfit Items (junction table)
CREATE TABLE IF NOT EXISTS outfit_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    outfit_id UUID NOT NULL REFERENCES outfits(id) ON DELETE CASCADE,
    clothing_item_id UUID NOT NULL REFERENCES clothing_items(id) ON DELETE CASCADE,
    position INTEGER DEFAULT 0,
    UNIQUE(outfit_id, clothing_item_id)
);

-- Outfit History
CREATE TABLE IF NOT EXISTS outfit_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    outfit_id UUID REFERENCES outfits(id) ON DELETE SET NULL,
    worn_date DATE NOT NULL DEFAULT CURRENT_DATE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    feedback TEXT,
    weather_actual TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User Favorites
CREATE TABLE IF NOT EXISTS user_favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    item_type VARCHAR(20) NOT NULL CHECK (item_type IN ('clothing', 'outfit')),
    item_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, item_type, item_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_clothing_items_user_id ON clothing_items(user_id);
CREATE INDEX IF NOT EXISTS idx_clothing_items_category ON clothing_items(category);
CREATE INDEX IF NOT EXISTS idx_clothing_items_created_at ON clothing_items(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_outfits_user_id ON outfits(user_id);
CREATE INDEX IF NOT EXISTS idx_outfits_occasion ON outfits(occasion);
CREATE INDEX IF NOT EXISTS idx_outfits_is_favorite ON outfits(is_favorite);
CREATE INDEX IF NOT EXISTS idx_outfit_history_user_id ON outfit_history(user_id);
CREATE INDEX IF NOT EXISTS idx_outfit_history_worn_date ON outfit_history(worn_date DESC);

-- Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE clothing_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE outfits ENABLE ROW LEVEL SECURITY;
ALTER TABLE outfit_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE outfit_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own profile"
    ON profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON profiles FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can view own clothing items"
    ON clothing_items FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own clothing items"
    ON clothing_items FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own clothing items"
    ON clothing_items FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own clothing items"
    ON clothing_items FOR DELETE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can view own outfits"
    ON outfits FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own outfits"
    ON outfits FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own outfits"
    ON outfits FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own outfits"
    ON outfits FOR DELETE
    USING (auth.uid() = user_id);

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, nickname)
    VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'nickname', '用户'));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_clothing_items_updated_at
    BEFORE UPDATE ON clothing_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_outfits_updated_at
    BEFORE UPDATE ON outfits
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
