using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class EventManager : MonoBehaviour
{
    public static UnityEvent addedToPlayerInputBar;

    void Start()
    {
        if (addedToPlayerInputBar == null)
        {
            addedToPlayerInputBar = new UnityEvent();
        }
    }
}
