Shader "Unlit/GalaxySkin"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FresnelCol ("Fresnel Color", color) = (1,1,1,1)
        _FresnelWidth("Fresnel Width", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float4 worldPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _FresnelCol;
            float _FresnelWidth;

            v2f vert (appdata v, out float4 outpos : SV_POSITION)
            {
                v2f o;
                o.worldNormal = UnityObjectToWorldNormal(v.normal.xyz);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                outpos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i, UNITY_VPOS_TYPE vpos : VPOS) : SV_Target
            {
                float3 worldSpaceViewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float fresnel = 1 - saturate(dot(worldSpaceViewDir, i.worldNormal));
                fresnel = smoothstep(1 - _FresnelWidth, 1, fresnel);

                fixed4 col = lerp(tex2D(_MainTex, vpos.xy / _ScreenParams.xy), _FresnelCol, fresnel);
                return col;
            }
            ENDCG
        }
    }
}
