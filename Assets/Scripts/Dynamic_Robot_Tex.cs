using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dynamic_Robot_Tex : MonoBehaviour {

    float Speed = 0.15f;
    float Offset = 0.0f;

    float ColorSpeed = 1.0f;
    float ColorFactor = 1.0f;
    float CurTime = 0.0f;

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        Offset += Time.deltaTime * Speed;

        //CurTime += Time.deltaTime;
        //ColorFactor = Mathf.Sin(ColorSpeed * CurTime);
        //ColorFactor = Mathf.Abs(ColorFactor);

        GetComponent<Renderer>().material.SetFloat("_Offset", Offset);
        GetComponent<Renderer>().material.SetFloat("_ColorFactor", ColorFactor);
        //GetComponent<Renderer>().material.SetFloat("_Color", 0f);

    }
}
