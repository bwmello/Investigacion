using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class BackgroundManager : MonoBehaviour
{
    [SerializeField]
    private Image myImageComponent;

    public Sprite guanajuatoImage;
    public Sprite mummyImage;

    void Start()
    {
        //myImageComponent = GetComponent<Image>();  // Causes undefined/null issue
        myImageComponent.preserveAspect = true;
        myImageComponent.sprite = guanajuatoImage;
    }

    public void LoadLocation(string newLocation)
    {
        switch (newLocation)
        {
            case "mummy_museum":
                myImageComponent.sprite = mummyImage;
                break;
            case "all_locations":
                myImageComponent.sprite = guanajuatoImage;
                break;
        }
    }

    public void ChangeBackgroundImage(Sprite newBackgroundImage)
    {
        myImageComponent.sprite = newBackgroundImage;
    }
}
