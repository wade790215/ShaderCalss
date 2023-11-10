Shader "Yile/Tutorial/UV"
{
    Properties
    {
        //來自SpriteRenderer / Image的圖片  關鍵字 "_MainTex"
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        //============================Variable==================

        //2D圖片
        _Texture("Texture", 2D) = "white" {}
        //顏色 (RGBA)
		_Color("Color", Color) = (1,1,1,1)
        //浮點數
        _Float("Float", Float) = 0
        //限制區間的浮點數
        _RangeFloat("Float", Range(0,1)) = 0
        //向量 (可理解為4個浮點數的集合體)
        _Vector("Vector",Vector) = (0,0,0,0)
        //切換選項 (開/關)
        [MaterialToggle] USETEXTURE("Use ShaderTex", Float) = 0




        //============================DefaultSetting==================
        [Header(Blending)]
    	[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend mode Source", Int) = 5
    	[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend mode Destination", Int) = 10

		// stencil for (UI) Masking
		_StencilComp("Stencil Comparison", Float) = 8
		_Stencil("Stencil ID", Float) = 0
		_StencilOp("Stencil Operation", Float) = 0
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		_StencilReadMask("Stencil Read Mask", Float) = 255
		_ColorMask("Color Mask", Float) = 15
    }
    SubShader
    {

       Tags { "Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent" }
		// stencil for (UI) Masking
		Stencil
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}
		Cull Off
		Lighting Off
		ZWrite Off
        Blend [_BlendSrc] [_BlendDst]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ USETEXTURE_ON

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float4 color    : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
                float4 vertex : SV_POSITION;
            };

            //==========================宣告使用變數===================
            sampler2D _Texture;
            float4 _Texture_ST;
            fixed4 _Color;
            float _Float,_RangeFloat;
            float4 _Vector;


            v2f vert (appdata v)
            {
                v2f o;

				o.color = v.color;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _Texture);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = fixed4(i.uv.x,i.uv.y,0,1);
                
                return col;
            }
            ENDCG
        }
    }
}
