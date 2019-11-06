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

    // UI Prefabs
    [SerializeField]
    private Text topTextPrefab;
    [SerializeField]
    private GameObject wordBubblePrefab;
    CharacterManager cm;
    GameManager gm;
    [SerializeField]
    BackgroundManager bm;
    //private Text displayText;  // Can't set displayText.text without making its type Text, and can't GameObject.FindWithTag("DisplayText") without type GameObject
    private GameObject playerInputBar;

    readonly System.Random random = new System.Random();
    public enum TagKeyWords { CHARACTER, LOCATION };

    void Start()
    {
        cm = GetComponent<CharacterManager>();
        gm = GetComponent<GameManager>();
        bm = GetComponent<BackgroundManager>();
        playerInputBar = GameObject.FindWithTag("PlayerInputBar");
        EventManager.addedToPlayerInputBar.AddListener(EvaluatePlayerInputBar);
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
        // Remove all Choice related GameObjects
        foreach (GameObject gameObjectToBeRemoved in GameObject.FindGameObjectsWithTag("InkChild"))
        {
            Destroy(gameObjectToBeRemoved);
        }

        // Remove all characters on screen
        cm.RemoveCharacters();

        // Read all the content until we can't continue any more
        while (story.canContinue)
        {
            Text storyText = Instantiate(topTextPrefab) as Text;
            storyText.text = story.Continue();  // Continue gets the next line of the story
            storyText.transform.SetParent(canvas.transform, false);
            EvaluateTags(story.currentTags);  // Must come after story.Continue() or correct tags not evaluated
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

    // If text in PlayerInputBar matches a choice, tell the story to choose that choice
    void EvaluatePlayerInputBar()
    {
        List<String> playerInputBarWords = new List<String>();
        foreach (Text word in playerInputBar.GetComponentsInChildren<Text>())
        {
            playerInputBarWords.Add(word.text);
        }
        string playerInputBarString = String.Join(" ", playerInputBarWords);
        foreach (Choice choice in story.currentChoices)
        {
            if (choice.text == playerInputBarString)
            {
                story.ChooseChoiceIndex(choice.index);
                RefreshView();
                break;
            }
        }
    }

    // Creates draggable choice WordBubbles from the choice text
    void CreateChoiceView(List<Choice> choicesList)
    {
        List<String> allChoiceWords = new List<String>();
        foreach (Choice choice in choicesList)
        {
            string[] choiceSplitIntoWords = choice.text.Split(' ');
            allChoiceWords = allChoiceWords.Union(choiceSplitIntoWords).ToList();
        }
        ShuffleWordList(allChoiceWords);
        RectTransform canvasRectTransform = canvas.GetComponent<RectTransform>();
        int sectionWidth = (int)canvasRectTransform.rect.width / allChoiceWords.Count;
        for (int i = 0; i < allChoiceWords.Count; i++)
        {
            // Alternative: UnityEngine.Random.insideUnitCircle * 5 with collision detection/avoidance
            int randomX = random.Next(i * sectionWidth + 20, (i + 1) * sectionWidth - 20) - (int)canvasRectTransform.rect.width / 2;
            int randomY = random.Next(13, 25) - (int)canvasRectTransform.rect.height / 2;
            Vector3 randomPosition = new Vector3(randomX, randomY, 500);
            GameObject wordBubble = Instantiate(wordBubblePrefab, new Vector3(0, 0, 0), Quaternion.identity, canvas.transform);
            wordBubble.GetComponentInChildren<Text>().text = allChoiceWords[i];
            wordBubble.transform.localPosition = randomPosition;
        }
    }

    // Creates draggable choice WordBubbles from the choice text
    // TODO get rid of this function and just make it a Choice instead of a String
    void CreateChoiceView(String choiceText)
    {
        List<String> allChoiceWords = new List<String>();
        string[] choiceSplitIntoWords = choiceText.Split(' ');
        allChoiceWords.AddRange(choiceSplitIntoWords);
        foreach (var word in allChoiceWords)
        {
            GameObject wordBubble = Instantiate(wordBubblePrefab, new Vector3(0, 0, 0), Quaternion.identity, canvas.transform);
            wordBubble.GetComponentInChildren<Text>().text = word;
        }
    }

    // Adapted from http://www.vcskicks.com/code-snippet/shuffle-array.php
    void ShuffleWordList(List<string> wordList)
    {
        if (wordList.Count > 1)
        {
            for (int i = wordList.Count-1; i >= 0; i--)
            {
                string tmp = wordList[i];
                int randomIndex = random.Next(i + 1);

                // Swap elements
                wordList[i] = wordList[randomIndex];
                wordList[randomIndex] = tmp;
            }
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
