using System;
//using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterManager : MonoBehaviour
{
    [SerializeField]
    GameObject securityGuard, mummyMuseumCurator, regionalMuseumCurator;

    //public enum Disposition { HOSTILE, UNFRIENDLY, NEUTRAL, FRIENDLY, HELPFUL };

    List<GameObject> activeCharacters = new List<GameObject>();


    void Awake() {}

    public void LoadCharacter(string newCharacter)
    {
        switch (newCharacter)
        {
            case "security_guard":
                activeCharacters.Add(Instantiate(securityGuard));
                break;
            case "mummy_museum_curator":
                activeCharacters.Add(Instantiate(mummyMuseumCurator));
                break;
            case "regional_museum_curator":
                activeCharacters.Add(Instantiate(regionalMuseumCurator));
                break;
        }
    }

    public void RemoveCharacters()
    {
        Debug.Log("!!!!RemoveCharacters called");
        foreach (GameObject activeCharacter in activeCharacters)
        {
            Destroy(activeCharacter);
        }
    }
}
