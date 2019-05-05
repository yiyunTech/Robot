using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;

public class RobotController : MonoBehaviour {
    float speed = 0.5f;
    float rotSpeed = 50;
    float rot = 0f;
    float gravity = 8;
    

    Vector3 moveDir = Vector3.zero;

    CharacterController controller;
    Animator anim;

    // Use this for initialization
    void Start () {
        controller = GetComponent<CharacterController>();
        anim = GetComponent<Animator>();
        Application.targetFrameRate = 30;
        Debug.Log("rate: " + Application.targetFrameRate);
	}
	
	// Update is called once per frame
	void Update () {
        if (Input.GetKey(KeyCode.A))
        {
            moveDir = new Vector3(1.0f, 0.0f, 0.0f);
            moveDir *= speed;
        }
        else if (Input.GetKeyUp(KeyCode.A))
        {
            moveDir = new Vector3(0.0f, 0.0f, 0.0f);
        }
        else if (Input.GetKey(KeyCode.D))
        {
            moveDir = new Vector3(-1.0f, 0.0f, 0.0f);
            moveDir *= speed;
        }
        else if (Input.GetKeyUp(KeyCode.D))
        {
            moveDir = new Vector3(0.0f, 0.0f, 0.0f);
        }


        controller.Move(moveDir * Time.deltaTime);



        if (Input.GetKey(KeyCode.Alpha0))
        {
            anim.SetInteger("Pose_Type", 0);
        }

        else if (Input.GetKey(KeyCode.Alpha1))
        {
            anim.SetInteger("Pose_Type", 1);
        }

        else if (Input.GetKey(KeyCode.Alpha2))
        {
            anim.SetInteger("Pose_Type", 2);
        }

        else if (Input.GetKey(KeyCode.Alpha3))
        {
            anim.SetInteger("Pose_Type", 3);
        }

        else if (Input.GetKey(KeyCode.Alpha9))
        {
            //anim.SetInteger("Pose_Type", 9);
            anim.enabled = false;
        }else if (Input.GetKey(KeyCode.Alpha4))
        {
            anim.enabled = true;
        }
    }
}
