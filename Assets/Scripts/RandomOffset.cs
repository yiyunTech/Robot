using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomOffset : MonoBehaviour {

    float FlushSpeed = 0f;
    System.Random CurRand;

    // Use this for initialiFlzation
    void Start()
    {
        CurRand = new System.Random();
    }

    // Update is called once per frame
    void Update()
    {
        float CurOffset1 = 0f;
        float CurOffset2 = 0f;
        CurOffset1 = (float)CurRand.NextDouble();
        CurOffset2 = (float)CurRand.NextDouble();


        //GetComponent<Renderer>().material.mainTextureOffset = new Vector2(CurOffset1, CurOffset2);

    }
}

