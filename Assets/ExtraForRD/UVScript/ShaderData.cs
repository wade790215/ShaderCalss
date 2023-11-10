using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ShaderData
{
    public Sprite sprite;
    public Vector2Int uvSize;

    public Color[] _pixels;
    public Color[] pixels
    {
        get
        {
            if (_pixels == null)
                _pixels = sprite.texture.GetPixels();
            return _pixels;
        }
    }
    public ShaderData(Sprite sp, Vector2Int size)
    {
        sprite = sp;
        uvSize = size;
    }

    public Vector2[] GetUVs()
    {
        List<Vector2> result = new List<Vector2>();


        for (int y = 0; y < uvSize.y; y++)
        {
            for (int x = 0; x < uvSize.x; x++)
            {
                result.Add(new Vector2((float)x / (float)uvSize.x, (float)y / (float)uvSize.y));
            }
        }

        return result.ToArray();

    }

    public Color GetColor(Vector2 uv)
    {

        int x = (int)Mathf.RoundToInt(spriteSize.x * (uv.x % 1));
        int y = (int)Mathf.RoundToInt(spriteSize.y * (uv.y % 1));

        int index = (y * (int)spriteSize.y) + x;
        // Debug.Log($"x:{x},y:{y}, index:{index}");
        return pixels[index];
    }

    public Vector2 spriteSize
    {
        get
        {
            return sprite.rect.size;
        }
    }

}

[System.Serializable]
public class UVData
{
    public Vector2 uv { get; private set; }
    private Color _color;
    public Color outColor
    {
        get
        {
            return _color;
        }
        set
        {
            _color = value;
            image.color = _color;
        }
    }
    private Image image;
    public UVData(Vector2 _uv, Image img, Color c)
    {
        uv = _uv;
        image = img;
        outColor = c;
    }
}
