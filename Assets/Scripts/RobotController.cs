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
            //anim.SetInteger("Pose_Type", 0);
            anim.SetTrigger("look");
        }

        else if (Input.GetKey(KeyCode.Alpha1))
        {
            //anim.SetInteger("Pose_Type", 1);
            anim.SetTrigger("jazz");
        }

        else if (Input.GetKey(KeyCode.Alpha2))
        {
            //anim.SetInteger("Pose_Type", 2);
            anim.SetTrigger("headbutt");
        }

        else if (Input.GetKey(KeyCode.Alpha3))
        {
            //anim.SetInteger("Pose_Type", 3);
            anim.SetTrigger("hurt");
        }

        else if (Input.GetKey(KeyCode.Alpha4))
        {
            //anim.SetInteger("Pose_Type", 3);
            anim.SetTrigger("walk");
        }

        else if (Input.GetKey(KeyCode.Alpha5))
        {
            //anim.SetInteger("Pose_Type", 3);
            anim.SetTrigger("catch");
        }

        else if (Input.GetKey(KeyCode.Alpha6))
        {
            //anim.SetInteger("Pose_Type", 3);
            anim.SetTrigger("blow");
        }
        else if (Input.GetKey(KeyCode.Alpha7))
        {
            //anim.SetInteger("Pose_Type", 3);
            anim.SetTrigger("roll");
        }
        else if (Input.GetKey(KeyCode.Alpha8))
        {
            //anim.SetInteger("Pose_Type", 9);
            anim.enabled = false;
        }else if (Input.GetKey(KeyCode.Alpha9))
        {
            anim.enabled = true;
        }
    }
}
