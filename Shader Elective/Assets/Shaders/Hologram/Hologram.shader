Shader "ElectiveShaders/Hologram"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_Power("Contrast", Float) = 1
		 
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 100
		Blend One One 
		ZWrite Off
		

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work

            #include "UnityCG.cginc"

            struct vertexData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 worldPos : TEXCOORD1; //Whyn ot derive from vertex?
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (vertexData v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = v.normal;
				float4 objectSpacePos = v.vertex;
				o.worldPos = mul(UNITY_MATRIX_M, objectSpacePos);
				o.normal = mul(UNITY_MATRIX_M, v.normal);
				return o;
            }

			float4 _Color;
			float _Power;

            float4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float4 col = tex2D(_MainTex, i.uv);
				
				col.xyz *= _Color;
				
				float3 viewDir = i.worldPos - _WorldSpaceCameraPos;
				viewDir = normalize(viewDir);
				i.normal = normalize(i.normal);
				float angleToCam = dot(i.normal.xyz, viewDir) * -1;
				
				float inverseFacing = 1 - angleToCam;
				return col * pow(inverseFacing, _Power);
            }
            ENDCG
        }
    }
}
