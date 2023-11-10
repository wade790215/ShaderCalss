Shader "Yile/Tutorial/Math/Distance"
{
    Properties
    {
        //來自SpriteRenderer / Image的圖片  關鍵字 "_MainTex"
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        //============================Variable==================
        _Radius("Radius",Range(0,1))=0

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
            #pragma multi_compile _ USEALPHA_ON

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
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Radius;

            float DistanceFromCenter(float2 uv)
			{
                // 根號(X平方+Y平方) = 斜邊
                float distance = sqrt(pow(uv.x - 0.5, 2) + pow(uv.y - 0.5, 2));
				return distance;
            }

            v2f vert (appdata v)
            {
                v2f o;

				o.color = v.color;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //原始圖片
                fixed4 col = tex2D(_MainTex,i.uv);

                //當前UV距離中心的距離
                float distance = DistanceFromCenter(i.uv);

                //超過設定距離才顯示
                float mask = step(_Radius,distance);

                col.a *= mask;

                return col;
            }
            ENDCG
        }
    }
}
