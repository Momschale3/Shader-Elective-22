Shader "Unlit/ToonLight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RampTex("Toon Ramp", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            /*
            - Assemble our Variables (get them tot the shader somehow)
                - Light intensity 
                - Surface Normal 
                    - Steal from Holo Shader
                - Get own World Position from Holo Shader
            - Calculate Lighting Info
                - Light Distance 
                - Light Direction 
            - Writing the functions 
                - Falloff Function 
                    - (one over distance squared)
                - Surface Interaction Function 
                    - (Lambert function with weird dot product)
            - Bring it all together 
                - use the functions 
                - return the color 


                ================================== TASKS ==============================
                1. Make Light color work and color the object in the color of the light
                2. Get Normal and return in it fragment shader, so we see normals on screen
                3. Steal World Position from Holo Shader
                4. Calculate LightDirection and LightDistance
                5. Function Writing - Falloff and Lambert Surface interaction 

            */

            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                //====TASK 3======
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _RampTex;
            //float4 _MainTex_ST;

            //ALREADY DECLARED IN UnityCG.engine
            //float4 _WorldSpaceLightPos0;
            fixed4 _LightColor0;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                //========= TASK 2 ========
                //World Normals
                o.normal = UnityObjectToWorldNormal(v.normal);
                //=========================
                
                //========= TASK 3 ========
                float4 objectSpacePos = v.vertex;
                o.worldPos = mul(UNITY_MATRIX_M, objectSpacePos);
                //=========================
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            //==========TASK 5 ==========

            float lightFaloff(float distance)
            {        
                return 1 / (distance * distance);
            }

            float lambertLighting(float3 lightDir, float3 normal)
            {
                return clamp(dot(lightDir, normal), 0, 1);
            }
            //=========================
            
            //========== TOON STUFF ==========
            fixed3 rampLighting(float3 lightDir, float3 normal)
            {
                float lambert = dot(lightDir, normal);
                
                //Remap the lambert from [-1,1] to [0,1]
                lambert = lambert * 0.5 + 0.5;

                fixed4 ramp = tex2D(_RampTex, lambert);

                return ramp.rgb;

            }

            //=========================

            fixed4 frag(v2f i) : SV_Target
            {
                //Calculate Light Direction and Distance
                float3 lightDirection;
                float lightDistance;

                if (_WorldSpaceLightPos0.w < 0.5)
                {
                    //Then we have a directional light
                    lightDistance = 1;
                    lightDirection = _WorldSpaceLightPos0.xyz;
                }
                else
                {
                    //We have Point Light
                    float3 lightPos = _WorldSpaceLightPos0.xyz;
                    float3 worldPos = i.worldPos;

                    //========= TASK 4 ==========
                    //lightDirection = normalize(-WorldSpaceLightDir(i.vertex));
                    

                    lightDirection = normalize(lightPos - worldPos);
                    lightDistance = distance(lightPos, worldPos);
                    //=========================
                }

                fixed4 albedo = tex2D(_MainTex, i.uv);

                fixed3 lightCol = _LightColor0 * 
                    lightFaloff(lightDistance) *
                    rampLighting(lightDirection, i.normal) *
                        albedo;

                //Because of Alpha 1 
                fixed4 col = fixed4(0, 0, 0, 1);
                col.rgb += lightCol;

                //======= TASK 1 ========
                //return col * _LightColor0;
                //=========================

                //======= TASK 2 ========                
                //col.rgb = i.normal.xyz;
                //=========================

                //======= TASK 3 ========
                //col.rgb = i.worldPos.xyz;
                //=========================

                return col;;
            }
            ENDCG
        }
    }
}
