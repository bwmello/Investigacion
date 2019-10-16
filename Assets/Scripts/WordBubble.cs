using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WordBubble : MonoBehaviour
{
    //private float startPosX;
    //private float startPosY;
    private bool isBeingHeld;
    private Vector2 startingPosition;
    //private bool overPlayerInput = false;
    //private List<Transform> touchingWordBubbles;
    //private AudioSource audSource;  // TODO implement as maraca sound

    private void Update()
    {
        if (isBeingHeld == true)
        {
            Vector2 mousePosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);  // From screen space to world space
            this.gameObject.transform.position = mousePosition - startingPosition;
        }
    }

    private void OnMouseDown()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Vector2 mousePosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            Vector2 myPosition = this.transform.position;
            startingPosition = mousePosition - myPosition;
            isBeingHeld = true;
        }
    }

    private void OnMouseUp()
    {
        isBeingHeld = false;
    }

    //private void Awake()
    //   {
    //	startingPosition = transform.position;
    //       touchingWordBubbles = new List<Transform>();
    //	//audSource = gameObject.GetComponent<AudioSource>();  // TODO implement as maraca sound
    //}

    //   public void PickUp()
    //{
    //	transform.localScale = new Vector3(1.1f, 1.1f, 1.1f);
    //	gameObject.GetComponent<SpriteRenderer>().sortingOrder = 1;
    //}

    //public void Drop()
    //{
    //       Debug.Log("!!!!Item dropped!!!! from WordBubble script");
    //       transform.localScale = new Vector3(1, 1, 1);
    //	gameObject.GetComponent<SpriteRenderer>().sortingOrder = 0;
    //}

    //void OnTriggerEnter2D(Collider2D other)
    //{
    //	Debug.Log("!!!!OnTriggerEnter2D() called, other.tag: " + other.tag);
    //	if (other.tag == "PlayerInput")
    //	{
    //		overPlayerInput = true;
    //	} // Switch statement? Does each overlapping object first its own OnTriggerEnter2D()?
    //	if (other.tag == "WordBubble" && !touchingWordBubbles.Contains(other.transform))
    //	{
    //		touchingWordBubbles.Add(other.transform);
    //	}
    //}

    //   void OnTriggerEnter(Collider other)
    //   {
    //       Debug.Log("!!!!OnTriggerEnter() called, other.tag: " + other.tag);
    //   }

    //   void OnCollisionEnter2D(Collision2D other)
    //   {
    //       Debug.Log("!!!!OnCollisionEnter2D() called");
    //       return;
    //   }

    //   void OnTriggerExit2D(Collider2D other)
    //{
    //	Debug.Log("!!!!OnTriggerExit2D() called, other.tag: " + other.tag);
    //	if (other.tag == "PlayerInput")
    //	{
    //		overPlayerInput = false;
    //	}
    //	if (touchingWordBubbles.Contains(other.transform))
    //	{
    //		touchingWordBubbles.Remove(other.transform);
    //	}
    //}
}
