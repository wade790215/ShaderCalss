using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public abstract class UVDemoBase : MonoBehaviour
{
    public Sprite mainTex;
    public Sprite normalTex;
    protected ShaderData mainTexData;
    public Vector2Int uvSize;

    public Image imageObj;

    public UVData[] uvDatas;
    public float updateSpeed;
    protected float timer;

    protected abstract void OnAwake();

    private void Awake()
    {
        mainTexData = new ShaderData(mainTex, uvSize);
        OnAwake();

        GenImage();

        StartCoroutine(UpdateColor());
    }

    private void GenImage()
    {
        var uvs = mainTexData.GetUVs();
        int counter = 0;
        List<UVData> uvDataList = new List<UVData>();
        for (int y = 0; y < uvSize.y; y++)
        {
            for (int x = 0; x < uvSize.x; x++)
            {
                Image image = Instantiate<Image>(imageObj, this.transform);
                image.rectTransform.anchoredPosition = new Vector2(x * 11, y * 11);
                Color color = mainTexData.GetColor(uvs[counter]);
                uvDataList.Add(new UVData(uvs[counter], image, color));
                counter++;
            }
        }
        uvDatas = uvDataList.ToArray();
        UpdateData();
    }

    private void FixedUpdate()
    {
        timer += Time.deltaTime;
    }

    IEnumerator UpdateColor()
    {
        while (true)
        {
            yield return new WaitForSeconds(updateSpeed);
            UpdateData();
        }
    }



    protected virtual void UpdateData()
    {
        foreach (UVData uvData in uvDatas)
        {
            ShaderUpdate(uvData);

        }
    }

    protected abstract void ShaderUpdate(UVData uvData);
}

