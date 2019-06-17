using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Character : MonoBehaviour
{
    public Image iconImage;
    public CharacterManager.Disposition myDisposition;

    public Character(Sprite characterIconImage)
    {
        myDisposition = CharacterManager.Disposition.NEUTRAL;
        iconImage.sprite = characterIconImage;
    }

    public void SetDisposition(CharacterManager.Disposition newDisposition)
    {
        //myDisposition = newDisposition;
        //spRend.sprite = emotionSprites[(int) myDisposition];
    }

    public void ShiftDisposition(int toShift)
    {
        //int newDispositionNum = (int) myDisposition + toShift;
        //if (newDispositionNum < 0)
        //{
        //    newDispositionNum = 0;
        //} else if (newDispositionNum > 4)
        //{
        //    newDispositionNum = 4;
        //}
        //SetDisposition((CharacterManager.Disposition) newDispositionNum);
    }
}
