using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;

public class RobotController : MonoBehaviour {
    public GameObject camera;
    float speed = 0.5f;
    float rotSpeed = 50;
    float rot = 0f;
    float gravity = 8;
    const float landingDistance = 0.05f;
    float rotateSpeed = 1.0f;
    Vector3 origin;
    Quaternion rotation;


    Vector3 moveDir = Vector3.zero;

    CharacterController controller;
    Animator anim;
    bool down = false;

    // Use this for initialization
    void Start () {
        controller = GetComponent<CharacterController>();
        anim = GetComponent<Animator>();
        origin = gameObject.transform.position;
        rotation = gameObject.transform.rotation;
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
            anim.SetTrigger("jump");
            Invoke("setDown", 3.0f);
            //setDown();
        }

        else if (Input.GetKey(KeyCode.Alpha1))
        {
            //anim.SetInteger("Pose_Type", 1);
            anim.SetTrigger("air");
            anim.ResetTrigger("jump");
            gameObject.transform.position = origin;
            gameObject.transform.rotation = rotation;
        }


        if (down)
        {
            RaycastHit hit;
            int layerMask = 1 << 8;
            layerMask = ~layerMask;
            if (Physics.Raycast(transform.position, Vector3.down, out hit, Mathf.Infinity, layerMask))
            {
                Debug.Log(hit.distance);
                if (hit.distance < landingDistance)
                {
                    down = false;
                    transform.rotation = Quaternion.Euler(0, 180 - camera.transform.eulerAngles.y, 0);
                }
            }

            gameObject.transform.position += Vector3.down * Time.deltaTime;
            gameObject.transform.position += Vector3.right * Time.deltaTime;
        }

        

       
    }

    void setDown()
    {
        down = true;
    }
}
