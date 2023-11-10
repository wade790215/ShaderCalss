using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestPixel : MonoBehaviour
{
    public Sprite sp;

    public Color[] pixels;
    private void Awake()
    {
        pixels = sp.texture.GetPixels();
    }
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
