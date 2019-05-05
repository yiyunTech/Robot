using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DynamicWall : MonoBehaviour {

    float Speed = 0.3f;
    float Offset = 0.0f;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        Offset += Time.deltaTime * Speed;

        GetComponent<Renderer>().material.mainTextureOffset = new Vector2(0, Offset);

    }
}
