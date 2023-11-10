using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VisualizedShaderExplain : UVDemoBase
{
    private ShaderData normalMapData;
    [Range(0, 1)]
    public float disortStrength;


    protected override void OnAwake()
    {
        normalMapData = new ShaderData(normalTex, uvSize);
    }

    
    protected override void ShaderUpdate(UVData uvData)
    {
        Color normal = normalMapData.GetColor(uvData.uv + new Vector2(timer, 0));
        float disortValue = normal.r;
        Color col = mainTexData.GetColor(uvData.uv + (new Vector2(disortValue, 0) * disortStrength));;
        uvData.outColor = col;
    }

}
