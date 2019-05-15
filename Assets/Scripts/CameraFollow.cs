using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour {

    public GameObject target;
    public float distance;
    public float yoffset;
	// Use this for initialization
	void Start () {
        distance = -5.0f;
        yoffset = -1.0f;
	}
	
	// Update is called once per frame
	void Update () {
        Vector3 pos = target.transform.transform.position;
        transform.position = new Vector3(pos.x, pos.y - yoffset, pos.z - distance);
	}
}
