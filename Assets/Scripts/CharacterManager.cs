using System;
//using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterManager : MonoBehaviour
{
    public Dictionary<string, Character> characters;
    public Sprite securityGuardImage;
    public Sprite mummyMuseumCuratorImage;
    public Sprite regionalMuseumCuratorImage;
    // = new Dictionary<string, Actor>
    //{
    //    ["security_guard"] = new Actor
    //};
    public enum Disposition { HOSTILE, UNFRIENDLY, NEUTRAL, FRIENDLY, HELPFUL };
    //[SerializeField]
    //Vector3 leftActorPosition, rightActorPosition;
    //List<Actor> activeActors = new List<Actor>();


    void Awake()
    {
        characters.Add("security_guard", new Character(securityGuardImage));
        characters.Add("mummy_museum_curator", new Character(mummyMuseumCuratorImage));
        characters.Add("regional_museum_curator", new Character(regionalMuseumCuratorImage));
        //for(int i = 0; i < characters.Count; i++)
        //{
        //    GameObject newActor = Instantiate(characters[i]);
        //    newActor.SetActive(false);
        //    newActor.name = characters[i].name;
        //    actorsList.Add(newActor);
        //}
    }

    public void LoadCharacter(string newCharacter)
    {
        //switch (newCharacter)
        //{
        //    case "security_guard":
        //        myImageComponent.sprite = mummyImage;
        //        break;
        //    case "all_locations":
        //        myImageComponent.sprite = guanajuatoImage;
        //        break;
        //}
    }

    public void PlaceActors(string leftActorName, string rightActorName)
    {
        //foreach (GameObject gO in actorsList)
        //{
        //    if (gO.name == leftActorName)
        //    {
        //        gO.SetActive(true);
        //        gO.GetComponent<Actor>().ID = 0;
        //        activeActors.Add(gO.GetComponent<Actor>());
        //        gO.transform.position = leftActorPosition;
        //    }
        //    else if (gO.name == rightActorName)
        //    {
        //        gO.SetActive(true);
        //        gO.GetComponent<Actor>().ID = 1;
        //        activeActors.Add(gO.GetComponent<Actor>());
        //        gO.transform.position = rightActorPosition;
        //    }
        //}
    }

    public void SetActorDisposition(string newDisposition, int ID)
    {
        //foreach (Actor actor in activeActors)
        //{
        //    if (actor.gameObject.activeInHierarchy)
        //    {
        //        if (actor.ID == ID)
        //        {
        //            if (Enum.TryParse(newDisposition, true, out Disposition matchedDisposition))
        //            {
        //                actor.SetDisposition(matchedDisposition);
        //            }
        //        }
        //    }
        //}
    }

    public void ShiftActorDisposition(int toShift, int ID)
    {
        //foreach (Actor actor in activeActors)
        //{
        //    if (actor.gameObject.activeInHierarchy)
        //    {
        //        if (actor.ID == ID)
        //        {
        //            actor.ShiftDisposition(toShift);
        //        }
        //    }
        //}
    }
}
