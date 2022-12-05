Shader "Unlit/VertexColor"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _RedTex ("Red Texture", 2D) = "white" {}
        _GreenTex("Green Texture", 2D) = "white" {}
        _BlueTex("Blue Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            //--------------------------------------------------------------------------------------
            
            //1. Get Vertex Color 
            //2. Move them to fragment shader
            //3. returning colors to screen

            //Task 2: 
            //Display Texture only where vertex color is red

            //Task 3:
            //Do it for green and blue vertex colors aswell and add 2 textures

            //------------------------------------------------------------------------------------- -

            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
             
                //-------------------------------------------Task 1.1-------------------------------------------

                float4 color : COLOR;

                //--------------------------------------------------------------------------------------        
    };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                //-------------------------------------------Task 1.1-------------------------------------------

                float4 color : COLOR;

                //--------------------------------------------------------------------------------------
            };

            //Main Tex
            sampler2D _MainTex;
            float4 _MainTex_ST;

            //Red Tex
            sampler2D  _RedTex;
            float4 _RedTex_ST;

            //Blue Tex
            sampler2D _BlueTex;
            float4 _BlueTex_ST;

            //Green Tex
            sampler2D _GreenTex;
            float4 _GreenTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);

                // -------------------------------------------Task 1.2-------------------------------------------

                o.color = v.color;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                /*
                fixed4 col;
                
                //-------------------------------------------Task 1.3-------------------------------------------
                //col = i.color;

               
                //-------------------------------------------Task 2 -------------------------------------------
                if (i.color.r > 0)
                {
                    col = tex2D(_RedTex, i.uv);
                }              
                
                //-------------------------------------------Task 3-------------------------------------------

                //For Green
                if (i.color.g > 0)
                {
                    col = tex2D(_GreenTex, i.uv);
                }

                //For Blue
                if (i.color.b > 0)
                {
                    col = tex2D(_BlueTex, i.uv);
                }

                //Main Texture
                if(i.color.r < 0.5 && i.color.b < 0.5 && i.color.g < 0.5)
                {
                    col = tex2D(_MainTex, i.uv);
                }

                return col;

               //--------------------------------------------------------------------------------------
                
                */
                
                
                
                /*
                
                //=============================OHNE IFS ========================================

                fixed4 baseTexture = tex2D(_MainTex, i.uv);
                baseTexture *= clamp(1 - (i.color.r + i.color.g + i.color.b), 0, 1);

                // ============ RED TEXTURE ============
                fixed4 redTexture = tex2D(_RedTex, i.uv);
                redTexture *= i.color.r;
                // ============ GREEN TEXTURE ============
                fixed4 greenTexture = tex2D(_GreenTex, i.uv);
                greenTexture *= i.color.g;
                // ============ BLUE TEXTURE ============
                fixed4 blueTexture = tex2D(_BlueTex, i.uv);
                blueTexture *= i.color.b;


                return baseTexture + redTexture + greenTexture + blueTexture;
                */
            }
            ENDCG
        }
    }
}
