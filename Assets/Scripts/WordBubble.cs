using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WordBubble : MonoBehaviour
{
    private BoxCollider2D myCollider;
    private Vector2 currentPosition;
    private Vector2 originalPosition;
    private bool isBeingHeld;
    //[SerializeField]
    //private AudioSource audSource;  // TODO implement as maraca sound
    private GameObject playerInputBar;  // Only used to reference its position and determine if event should be fired

    private void Start()
    {
        myCollider = GetComponent<BoxCollider2D>();
        originalPosition = transform.position;
        playerInputBar = GameObject.FindWithTag("PlayerInputBar");  // TODO Is it more efficient to have InkManager set this for WordBubble after instantiating it?
        //audSource = gameObject.GetComponent<AudioSource>();  // TODO implement as maraca sound
        StartCoroutine(WaitUntilEndOfStartFrame());
    }

    IEnumerator WaitUntilEndOfStartFrame()
    {
        yield return new WaitForEndOfFrame();
        RectTransform myRectTransform = GetComponent<RectTransform>();  // LayoutGroup doesn't set width/height until 1 frame after Start()
        myCollider.size = new Vector2(myRectTransform.rect.width, myRectTransform.rect.height);
    }

    private void Update()
    {
        if (isBeingHeld == true)
        {
            Vector2 mousePosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);  // From screen space to world space
            this.gameObject.transform.position = mousePosition - currentPosition;
        }
    }

    private void OnMouseDown()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Vector2 mousePosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            Vector2 myPosition = this.transform.position;
            currentPosition = mousePosition - myPosition;
            isBeingHeld = true;
        }
    }

    private void OnMouseUp()
    {
        isBeingHeld = false;
        if (myCollider.IsTouching(playerInputBar.GetComponent<BoxCollider2D>()))
        {
            transform.SetParent(playerInputBar.transform);
        }
    }
}
