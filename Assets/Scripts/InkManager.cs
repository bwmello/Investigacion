using System;
//using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using Ink.Runtime;
using System.Linq;

public class InkManager : MonoBehaviour
{
    [SerializeField]
    private TextAsset inkJSONAsset;
    private Story story;

    [SerializeField]
    private Canvas canvas;

    public enum TagKeyWords { CHARACTER, LOCATION };

    // UI Prefabs
    [SerializeField]
    private Text textPrefab;
    //[SerializeField]
    //private Button buttonPrefab;
    [SerializeField]
    private GameObject wordBubblePrefab;
    CharacterManager cm;
    GameManager gm;
    [SerializeField]
    BackgroundManager bm;

    void Start()
    {
        cm = GetComponent<CharacterManager>();
        gm = GetComponent<GameManager>();
        bm = GetComponent<BackgroundManager>();
        StartStory();
    }

    // Creates a new Story object with the compiled story which we can then play!
    void StartStory()
    {
        story = new Story(inkJSONAsset.text);
        RefreshView();
    }

    // This is the main function called every time the story changes. It does a few things:
    // Destroys all the old content and choices.
    // Continues over all the lines of text, then displays all the choices. If there are no choices, the story is finished!
    void RefreshView()
    {
        // Remove all the UI on screen
        RemoveChildren();

        // Remove all characters on screen
        cm.RemoveCharacters();

        // Read all the content until we can't continue any more
        while (story.canContinue)
        {
            // Continue gets the next line of the story
            string text = story.Continue();
            EvaluateTags(story.currentTags);
            // This removes any white space from the text.
            text = text.Trim();
            // Display the text on screen!
            CreateContentView(text);
        }

        // Display all the choices, if there are any!
        if (story.currentChoices.Count > 0)
        {
            CreateChoiceView(story.currentChoices);
        }
        // If we've read all the content and there's no choices, the story is finished!
        else
        {
            //Button choice = CreateChoiceView("End of story.\nRestart?");
            //Choice endOfStoryChoice = 
            CreateChoiceView("End of story.\nRestart?");
            //choice.onClick.AddListener(delegate {  // TODO
            //    StartStory();
            //});
        }
    }

    // When we click the choice button, tell the story to choose that choice!
    void OnClickChoiceButton(Choice choice)
    {
        story.ChooseChoiceIndex(choice.index);
        RefreshView();
    }

    // Creates a button showing the choice text
    void CreateContentView(string text)
    {
        Text storyText = Instantiate(textPrefab) as Text;
        storyText.text = text;
        storyText.transform.SetParent(canvas.transform, false);
    }

    // Creates draggable choice WordBubbles from the choice text
    void CreateChoiceView(List<Choice> choicesList)
    {
        List<String> allChoiceWords = new List<String>();
        foreach (var choice in choicesList)
        {
            var choiceFormattedText = choice.text.Trim().ToLower();
            string[] choiceSplitIntoWords = choiceFormattedText.Split(' ');
            allChoiceWords.AddRange(allChoiceWords.Union(choiceSplitIntoWords).ToList());
        }
        foreach (var word in allChoiceWords)
        {
            GameObject wordBubble = Instantiate(wordBubblePrefab);
            wordBubble.transform.SetParent(canvas.transform, false);

            // Gets the text from the button prefab
            Text wordBubbleText = wordBubble.GetComponentInChildren<Text>();
            wordBubbleText.text = word;

            // Make the button expand to fit the text
            HorizontalLayoutGroup layoutGroup = wordBubble.GetComponent<HorizontalLayoutGroup>();
            layoutGroup.childForceExpandHeight = false;
        }
    }

    // Creates draggable choice WordBubbles from the choice text
    void CreateChoiceView(String choiceText)
    {
        List<String> allChoiceWords = new List<String>();
        var choiceFormattedText = choiceText.Trim().ToLower();
        string[] choiceSplitIntoWords = choiceFormattedText.Split(' ');
        allChoiceWords.AddRange(choiceSplitIntoWords);
        foreach (var word in allChoiceWords)
        {
            GameObject wordBubble = Instantiate(wordBubblePrefab);
            wordBubble.transform.SetParent(canvas.transform, false);

            // Gets the text from the button prefab
            Text wordBubbleText = wordBubble.GetComponentInChildren<Text>();
            wordBubbleText.text = word;

            // Make the button expand to fit the text
            HorizontalLayoutGroup layoutGroup = wordBubble.GetComponent<HorizontalLayoutGroup>();
            layoutGroup.childForceExpandHeight = false;
        }
    }

        // Destroys all the children of this gameobject (all the UI)
        void RemoveChildren()
    {
        int childCount = canvas.transform.childCount;
        for (int i = childCount - 1; i >= 0; --i)
        {
            Destroy(canvas.transform.GetChild(i).gameObject);
        }
    }

    public void EvaluateTags(List<string> currentTags)
    {
        foreach (var currentTag in currentTags)
        {
            string[] tagBrokenUp = currentTag.Split(' ');
            if (tagBrokenUp.Length == 2)  // Change if we ever do a format other than "#tagKeyWord singleParamater"
            {
                if (Enum.TryParse(tagBrokenUp[0], true, out TagKeyWords theTagKeyWord))
                {
                    switch (theTagKeyWord)
                    {
                        case TagKeyWords.CHARACTER:
                            cm.LoadCharacter(tagBrokenUp[1]);
                            break;
                        case TagKeyWords.LOCATION:
                            bm.LoadLocation(tagBrokenUp[1]);
                            break;
                    }
                }
            }
        }
    }
}
