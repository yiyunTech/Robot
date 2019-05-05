using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraSwitch : MonoBehaviour {

    public GameObject MainCamera;
    public GameObject AssistCamera;
    public bool UseMainCamera = true;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
        if(UseMainCamera)
        {
            MainCamera.SetActive(true);
            AssistCamera.SetActive(false);
        }
        else
        {
            MainCamera.SetActive(false);
            AssistCamera.SetActive(true);
        }
	}
}
