// Supabase Edge Function: recommend-outfit
// AI-powered outfit recommendation

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface OutfitItem {
  id: string;
  name: string;
  category: string;
  color: string;
  colorHex?: string;
  imageUrl?: string;
}

interface RecommendRequest {
  occasion: string;
  style?: string;
  weather?: {
    temp: number;
    condition: string;
  };
  userPreferences?: {
    stylePreferences?: string[];
    colorPreferences?: string[];
    avoidColors?: string[];
    bodyShape?: string;
  };
  wardrobeItems: OutfitItem[];
  count?: number;
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const {
      occasion,
      style,
      weather,
      userPreferences,
      wardrobeItems,
      count = 3,
    }: RecommendRequest = await req.json();

    const openAiKey = Deno.env.get("OPENAI_API_KEY");
    if (!openAiKey) {
      throw new Error("OPENAI_API_KEY not configured");
    }

    // Build prompt for outfit recommendation
    const systemPrompt = `你是一个专业的时尚穿搭顾问。你需要根据用户的衣橱、场合需求和天气情况，推荐最佳穿搭方案。

穿搭分类说明：
- 上衣：T恤、衬衫、毛衣、卫衣、针织衫等
- 裤子：牛仔裤、休闲裤、短裤、阔腿裤等
- 裙子：连衣裙、半身裙、短裙等
- 外套：夹克、大衣、风衣、羽绒服等
- 配饰：帽子、围巾、手套、项链等
- 鞋：运动鞋、帆布鞋、高跟鞋、靴子等
- 包：单肩包、双肩包、手提包等

规则：
1. 只使用用户衣橱中已有的衣物
2. 每套穿搭应包含2-5件单品
3. 根据场合调整正式程度
4. 注意颜色搭配协调（可参考色彩搭配原理）
5. 根据天气选择合适厚薄的衣物
6. 考虑用户的身材特点给出扬长避短的建议

输出格式必须是JSON：
{
  "outfits": [
    {
      "name": "穿搭名称",
      "itemIds": ["衣物ID列表"],
      "reasoning": "推荐理由（2-3句话）",
      "styleNotes": "造型建议",
      "confidence": 0.0到1.0的置信度
    }
  ]
}`;

    const userPrompt = `
用户需求：
- 场合：${occasion}
${style ? `- 风格偏好：${style}` : ""}
${weather ? `- 天气：${weather.temp}°C，${weather.condition}` : ""}
${userPreferences?.stylePreferences?.length ? `- 风格偏好：${userPreferences.stylePreferences.join("、")}` : ""}
${userPreferences?.colorPreferences?.length ? `- 喜欢的颜色：${userPreferences.colorPreferences.join("、")}` : ""}
${userPreferences?.avoidColors?.length ? `- 避免的颜色：${userPreferences.avoidColors.join("、")}` : ""}
${userPreferences?.bodyShape ? `- 身材类型：${userPreferences.bodyShape}` : ""}

用户衣橱（共${wardrobeItems.length}件）：
${wardrobeItems.map((item, i) => `${i + 1}. ${item.name} - ${item.category} - ${item.color}`).join("\n")}

请推荐${count}套穿搭方案。
`;

    // Call OpenAI API
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${openAiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "gpt-4-turbo",
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: userPrompt },
        ],
        response_format: { type: "json_object" },
        temperature: 0.7,
        max_tokens: 2000,
      }),
    });

    if (!response.ok) {
      throw new Error(`OpenAI API error: ${response.status}`);
    }

    const data = await response.json();
    const content = data.choices[0]?.message?.content;

    // Parse JSON from response
    const result = JSON.parse(content);

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
