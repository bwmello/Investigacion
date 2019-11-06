using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class WordBubble : MonoBehaviour
{
    //[SerializeField]
    //private Text textPrefab;

    private BoxCollider2D myCollider;
    private Vector2 currentPosition;
    private bool isBeingHeld;
    //[SerializeField]
    //private AudioSource audSource;  // TODO implement as maraca sound
    private GameObject playerInputBar;
    public delegate void WordBubbleAction();
    public static event WordBubbleAction AddedToPlayerInputBar;

    private void Start()
    {
        myCollider = GetComponent<BoxCollider2D>();
        playerInputBar = GameObject.FindWithTag("PlayerInputBar");
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
            transform.position = mousePosition - currentPosition;
        }
    }

    private void OnMouseDown()
    {
        if (Input.GetMouseButtonDown(0))
        {
            transform.SetParent(playerInputBar.transform.parent);  // Make parent the UI Canvas so WordBubble can be dragged outside of playerInputBar
            Vector2 mousePosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            Vector2 myPosition = transform.position;
            currentPosition = mousePosition - myPosition;
            isBeingHeld = true;
        }
    }

    private void OnMouseUp()
    {
        isBeingHeld = false;
        if (myCollider.IsTouching(playerInputBar.GetComponent<BoxCollider2D>())) {
            if (playerInputBar.transform.childCount > 0)
            {
                for (int i = playerInputBar.transform.childCount-1; i >= 0; i--)
                {
                    if (Camera.main.WorldToScreenPoint(transform.position).x >= Camera.main.WorldToScreenPoint(playerInputBar.transform.GetChild(i).position).x)
                    {
                        transform.SetParent(playerInputBar.transform);
                        transform.SetSiblingIndex(i+1);
                        break;
                    }
                    else if (i == 0)
                    {
                        transform.SetParent(playerInputBar.transform);
                        transform.SetSiblingIndex(0);
                    }
                }
            }
            else
            {
                transform.SetParent(playerInputBar.transform);
            }
            EventManager.addedToPlayerInputBar.Invoke();
        }  // TODO else { don't allow WordBubble to be placed outside of area nor over/under another WordBubble }
    }
}
