// Supabase Edge Function: analyze-image
// AI-powered clothing recognition using OpenAI Vision

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface AnalyzeRequest {
  imageBase64: string;
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { imageBase64 }: AnalyzeRequest = await req.json();

    // Get environment variables
    const openAiKey = Deno.env.get("OPENAI_API_KEY");
    if (!openAiKey) {
      throw new Error("OPENAI_API_KEY not configured");
    }

    // Call OpenAI Vision API for clothing recognition
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${openAiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "gpt-4o",
        messages: [
          {
            role: "user",
            content: [
              {
                type: "text",
                text: `你是一个专业的时尚穿搭助手。请分析这张衣物图片，返回JSON格式的识别结果：
{
  "category": "上衣/裤子/裙子/外套/配饰/鞋/包/首饰/口红",
  "subCategory": "具体类型，如：T恤、牛仔裤、连衣裙等",
  "color": "主要颜色（中文）",
  "colorHex": "#RRGGBB格式的十六进制颜色",
  "brand": "品牌名称（如有）",
  "material": "材质（如：棉、羊毛、丝绸等）",
  "styleTags": ["风格标签，如：简约、休闲、通勤等"],
  "season": ["适合季节，春/夏/秋/冬"],
  "occasion": ["适合场合，通勤/约会/面试/运动/逛街/居家/旅行/聚会/日常"],
  "confidence": 0.0到1.0的置信度
}`
              },
              {
                type: "image_url",
                image_url: { url: `data:image/jpeg;base64,${imageBase64}` }
              }
            ]
          }
        ],
        max_tokens: 1000,
      }),
    });

    if (!response.ok) {
      throw new Error(`OpenAI API error: ${response.status}`);
    }

    const data = await response.json();
    const content = data.choices[0]?.message?.content;

    // Parse JSON from response
    const jsonMatch = content.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      throw new Error("Failed to parse AI response");
    }

    const result = JSON.parse(jsonMatch[0]);

    return new Response(JSON.stringify({
      success: true,
      data: result,
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });

  } catch (error) {
    return new Response(JSON.stringify({
      success: false,
      error: error.message,
    }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
