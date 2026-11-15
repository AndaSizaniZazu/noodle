-- Course: "Planning Lessons with AI: Grade R to 7" (slug lesson-prep-r7)
-- 10 modules x 3 lessons = 30 lessons, 4 quiz questions per module.
-- Plain English for teachers whose first language is not English. Example prompts (in > quotes) stay in English.
-- Re-running this file replaces the course (and any progress on it). Other courses are not touched.

delete from public.courses where slug = 'lesson-prep-r7';

insert into public.courses (slug, title, summary)
values ('lesson-prep-r7',
        $t$Planning Lessons with AI: Grade R to 7$t$,
        $t$A practical course for Foundation, Intermediate and Grade 7 teachers. Use AI to prepare CAPS lessons faster: play activities for Grade R, phonics and maths for Grades 1–3, English support from Grade 4, worksheets, experiments, multi-grade classes and weekly plans — with you checking every step.$t$);

------------------------------------------------------------------
-- MODULE 1
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-r7';

    insert into public.modules (course_id, position, title, summary)
    values (c, 1, $t$Planning with AI: the basics$t$,
            $t$Why AI helps with lesson preparation, what to give it, and one prompt recipe you can use for every lesson.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Why plan lessons with AI?$t$, 8, $md$
**In this lesson** you will see how AI can save you time when you prepare lessons, and where you must stay in charge.

## Planning takes a lot of time

A good lesson needs many things. You need an aim. You need an opening activity. You need examples, an activity for the learners, and a way to check what they learned. Many primary teachers teach **many subjects**. Some teach **two grades in one room**. Planning every lesson from an empty page is hard.

## Where AI helps

AI can give you a **first draft** in one or two minutes:

- a lesson plan with clear steps
- ideas for a game, song or story
- examples and questions at the right level
- a worksheet with an easy part and a harder part
- a short explanation in simple words

You do not have to use everything. Take the good parts. Leave the rest.

## Where you stay in charge

The AI does not know your learners. It does not know that half the class was absent yesterday. It does not know that you have no photocopier. **You** know these things. So:

1. **You** choose the topic from CAPS and your ATP.
2. The **AI** drafts.
3. **You** check, change and decide.

## A real example

Mrs Ndlovu teaches Grade 3 in Mthatha. She asked the AI for three ways to teach "telling the time to the half hour". She liked one idea: making clocks from paper plates. She changed the times to match the school day: 7:30 (school starts) and 10:30 (break). In 15 minutes she had a plan that felt like *her* lesson.

## Key words

| Word | Simple meaning |
|---|---|
| Lesson preparation | Getting ready to teach: planning steps, activities and resources |
| Draft | A first try that you will check and improve |
| ATP | Annual Teaching Plan — the plan that says what to teach each week of the term |

**Remember:** AI gives you a starting point. Your knowledge of your class makes it a good lesson.
$md$,
     $t$Think of one lesson you will teach next week. Ask the AI: "I am a Grade [your grade] teacher. Give me 3 different ways to start a lesson on [your topic]." Choose the idea you like best.$t$),

    (m, 2, $t$Give the AI your planning information$t$, 10, $md$
**In this lesson** you will learn which information to give the AI so its plan matches CAPS and your class.

## The AI only knows what you tell it

If you write "Make a maths lesson", the AI must guess everything: the grade, the topic, the time, the language. It will guess wrongly. If you give it your **planning information**, it can make a plan that fits.

## The information to give

Before you ask, look at your **CAPS document** and your **ATP**. Then tell the AI:

- **Grade and subject** — "Grade 2 Mathematics"
- **Term and week** — "Term 2, Week 4"
- **Topic and skill from the ATP** — copy the words exactly
- **Lesson length** — "45 minutes" or "30 minutes"
- **Language of learning and teaching (LoLT)** — isiXhosa or English
- **Your class** — how many learners, their level, any special needs (no names!)
- **Your resources** — chalkboard, counters, bottle tops, a reader, no photocopier

## Copy the ATP words

The ATP uses exact words, for example *"Count forwards and backwards in 2s, 5s and 10s from any number between 0 and 200"*. Copy these words into your prompt. Then the AI teaches the right skill at the right level.

> I teach Grade 2 Mathematics, Term 2, Week 4. The ATP says: "Count forwards and backwards in 2s, 5s and 10s from any number between 0 and 200." My lesson is 45 minutes. The language of teaching is isiXhosa, but please write the plan in English. I have 48 learners and bottle tops, a chalkboard and a number chart. Please plan this lesson.

## Never share private learner information

Do **not** type learners' names, ID numbers, marks or home problems. Say "one learner who cannot see the board well", not the learner's name.

## Key words

| Word | Simple meaning |
|---|---|
| CAPS | Curriculum and Assessment Policy Statement — what must be taught in each grade |
| LoLT | Language of learning and teaching — the language you teach in |
| Resources | The things you can use: books, counters, charts, objects |

**Remember:** Good information in, good plan out. Copy the ATP words.
$md$,
     $t$Open your ATP for next week. Write down: grade, subject, term, week, the exact ATP words, lesson length, language, class size and resources. Keep this list — you will use it in the next lesson.$t$),

    (m, 3, $t$The lesson-prep prompt recipe$t$, 10, $md$
**In this lesson** you will learn one prompt recipe that works for almost every lesson you plan.

## Start with RTCF

In the first Noodle course you learned **RTCF**: **R**ole, **T**ask, **C**ontext, **F**ormat. For lesson planning we use the same recipe and add your planning information.

| Part | What to write | Example |
|---|---|---|
| **Role** | Who the AI should be | "You are an experienced Foundation Phase teacher in the Eastern Cape." |
| **Task** | What it must make | "Plan a 30-minute lesson." |
| **Context** | Your planning information | Grade, term, week, ATP words, class, resources |
| **Format** | How it must look | "Use headings: Aim, Resources, Introduction, Main activity, Conclusion, Assessment." |

## The recipe as a template

Copy this template and fill in the brackets:

> You are an experienced [phase] teacher in a South African public school in the Eastern Cape. Plan a [length]-minute lesson for Grade [grade] [subject], Term [term], Week [week]. The ATP topic is: "[exact ATP words]". My class has [number] learners. The language of teaching is [language]. Resources I have: [list]. Use these headings: Aim, Resources, Introduction (5 minutes), Main activity, Group or pair work, Conclusion, How I will check learning. Use simple English and keep it to one page.

## Why one recipe helps

When you use the same recipe every time:

- you do not forget important information
- the plans all look the same, so they are easy to file and read
- you can share the template with colleagues in your phase

## Change one part at a time

Not happy with the answer? Do not start again. Ask for a change: *"Make the main activity more active"* or *"Add an easier task for learners who struggle."* We practise this in Module 10.

## Key words

| Word | Simple meaning |
|---|---|
| Recipe | Fixed steps you follow every time, like in cooking |
| Template | A prompt with gaps [ ] that you fill in each time |
| Heading | A title for each part of the plan |

**Remember:** Role + Task + Context + Format = a lesson plan you can use.
$md$,
     $t$Use the list you made in Lesson 2. Fill in the template from this lesson and paste it into an AI tool (or the Noodle Playground). Read the plan. Mark one thing you will keep and one thing you will change.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$What is the best way to use AI for lesson planning?$t$,
        $j$["Let the AI draft, then you check, change and decide","Copy the AI plan without reading it","Let the AI choose the CAPS topic for you","Only use AI for subjects you do not like"]$j$,
        0, $t$AI drafts quickly, but you know CAPS, your ATP and your learners. You make the final decisions.$t$),
    (m, 2, $t$Why should you copy the exact words from the ATP into your prompt?$t$,
        $j$["Because the AI cannot read short sentences","So the AI teaches the right skill at the right level","So the answer is longer","Because it is a rule of the AI company"]$j$,
        1, $t$The ATP words say exactly what skill and number range to teach. The AI can then match them.$t$),
    (m, 3, $t$Which of these should you NEVER type into an AI tool?$t$,
        $j$["The grade and subject","The resources you have","A learner's name and marks","The length of the lesson"]$j$,
        2, $t$Learners' names, ID numbers, marks and private problems must stay private. Describe needs without names.$t$),
    (m, 4, $t$In the lesson-prep recipe, what does "Format" mean?$t$,
        $j$["The subject you teach","The person the AI must act as","The time of day you teach","How the plan must look, for example the headings"]$j$,
        3, $t$Format is the shape of the answer: headings, a table, one page, simple English.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 2
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-r7';

    insert into public.modules (course_id, position, title, summary)
    values (c, 2, $t$Grade R: learning through play$t$,
            $t$Use AI to plan themes, ring time, stories, songs and play activities for Grade R with simple, cheap resources.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Planning a Grade R theme and daily programme$t$, 10, $md$
**In this lesson** you will use AI to plan a Grade R theme and fill the daily programme with play-based activities.

## Grade R is different

In Grade R, children learn by **playing, moving, talking and doing**. They do not sit at desks for long. CAPS for Grade R is organised around **themes**, such as *My body*, *My family*, *Animals*, *Transport* or *Water*. A day has a routine: arrival, ring time, free play, a story, outdoor play, snack time and tidy-up.

## Ask the AI to plan a theme week

Tell the AI the theme, the week, the length of the day and the three subjects: **Home Language**, **Mathematics** and **Life Skills**.

> You are an experienced Grade R practitioner in the Eastern Cape. Plan one week (5 days) for the theme "Transport". For each day give: a ring time idea (5–10 minutes), one Home Language activity, one Mathematics activity, one Life Skills or creative activity, and one outdoor game. Children are 5 and 6 years old. Use cheap materials such as boxes, bottle tops, chalk and old magazines. Use a table with one row per day.

## Make it local

Children learn best from things they know. Ask the AI to use **local examples**: taxis and buses, donkey carts, bakkies, the local spaza shop, cows and goats. You can add: *"Use examples from a rural village in the Eastern Cape."*

## Check the plan for Grade R

Look at what the AI gives you. Ask yourself:

- Are the children **moving and playing**, not only sitting and writing?
- Are activities **short** (10–15 minutes)?
- Is there **talking** in the Home Language?
- Can I find the materials **for free or very cheaply**?

If not, ask the AI to change it: *"Make Tuesday more active. Replace the worksheet with a game."*

## Key words

| Word | Simple meaning |
|---|---|
| Theme | One big topic for a week or two, like "Transport" |
| Ring time | When children sit in a circle with the teacher to talk, sing and learn |
| Daily programme | The plan for the whole school day, in order |

**Remember:** In Grade R, play is the lesson. Ask the AI for activities children can *do*.
$md$,
     $t$Choose the next theme in your Grade R programme (or any theme). Use the example prompt but change the theme. Check: is every day active, short and cheap? Ask the AI to fix one day that is not.$t$),

    (m, 2, $t$Stories, songs and rhymes$t$, 10, $md$
**In this lesson** you will ask AI for stories and songs for young children — and learn why you must check them carefully, especially in isiXhosa.

## Why stories and songs matter

Stories and rhymes build **listening, new words and a love of language**. Children remember songs with actions much better than lists of words.

## Asking for a story

Give the AI the theme, the age, the length and the words you want children to learn.

> Write a short story for Grade R children (5–6 years old) on the theme "My body". Length: about 150 words. Use very simple sentences. The main character is a little boy called Lutho who lives in a village near Mthatha. Include these words: head, eyes, ears, hands, feet. End with 3 easy questions I can ask the children.

## Asking for a song or action rhyme

> Write a short action rhyme (4 lines, repeated) for Grade R about washing hands. Give a simple action for each line. Use a tune like a well-known children's song so it is easy to sing.

## Be careful with isiXhosa

AI tools are **much stronger in English than in isiXhosa**. When you ask for isiXhosa rhymes, songs or stories:

- the grammar may be wrong
- the rhythm may not work when you sing it
- some words may be strange or old

A good method: ask the AI for the **idea and structure in English**. Then **you** write or adapt the isiXhosa version, or ask a colleague. You can also use **traditional isiXhosa songs and rhymes** you already know — the AI can suggest actions or new verses for them.

## Check the story

- Are the sentences short enough for 5-year-olds?
- Are the names, places and food familiar to your learners?
- Is there anything scary, unfair or not suitable?

## Key words

| Word | Simple meaning |
|---|---|
| Action rhyme | A short poem with movements, like clapping or touching your head |
| Character | A person or animal in a story |
| Adapt | Change something so it fits your class better |

**Remember:** Use the AI for ideas and structure. Check every word that young children will hear.
$md$,
     $t$Ask the AI for a 150-word Grade R story on a theme of your choice, with a local character and 5 key words. Then change at least two things so it fits your learners better.$t$),

    (m, 3, $t$Play activities with simple resources$t$, 10, $md$
**In this lesson** you will use AI to find learning games and activities that use free or cheap materials, indoors and outdoors.

## You do not need expensive toys

Children can learn counting, sorting, colours, shapes and patterns with **bottle tops, stones, sticks, seeds, boxes, old bottles and chalk**. Tell the AI what you have, and ask it to build activities around these things.

> I teach Grade R in a school with very few resources. I have bottle tops, small stones, sticks, empty boxes, chalk and a big outside area. Give me 6 Mathematics play activities for "sorting and counting to 10". For each activity give: the name, what I need, what to do (3–4 steps), and what to say to the children. Keep each activity to 10 minutes.

## Indoor and outdoor

Ask for both. Outdoor play helps **gross motor skills** (big movements like running, jumping, throwing). Indoor activities help **fine motor skills** (small movements like threading, tearing paper, holding a crayon).

> Give me 3 outdoor games and 3 indoor table activities that build fine and gross motor skills for Grade R. Use only cheap or free materials.

## Ask for safety notes

With young children, always ask: *"Add a safety note for each activity."* Small objects like seeds and bottle tops can be swallowed. The AI may forget this unless you ask.

## Make a resource list for the term

Ask the AI to make a list of **free materials** to collect for the whole term. Send it to parents. They can bring clean boxes, bottle tops and old magazines from home.

## Key words

| Word | Simple meaning |
|---|---|
| Fine motor skills | Using small muscles in the hands and fingers |
| Gross motor skills | Using big muscles: running, jumping, climbing |
| Sorting | Putting things into groups, e.g. by colour or size |

**Remember:** Tell the AI what you *have*, not what you *wish* you had.
$md$,
     $t$List 5 free materials you can find at your school. Ask the AI for 4 Grade R activities using only those materials, with a safety note for each. Try one activity this week.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$How do Grade R children learn best?$t$,
        $j$["By sitting at desks and copying from the board all day","By doing long written tests","By playing, moving, talking and doing","By watching videos only"]$j$,
        2, $t$Grade R learning is play-based. Activities should be short, active and full of talk.$t$),
    (m, 2, $t$You want an isiXhosa rhyme for your Grade R class. What is a good method?$t$,
        $j$["Use the AI's isiXhosa without checking","Get the idea from the AI in English, then write or check the isiXhosa yourself or with a colleague","Never use isiXhosa in Grade R","Ask the AI to translate a long English poem word for word"]$j$,
        1, $t$AI is weaker in isiXhosa. Use it for ideas and structure, and let a fluent speaker write or check the words.$t$),
    (m, 3, $t$What should you tell the AI when asking for play activities?$t$,
        $j$["Only the children's names","Nothing — it already knows your school","The price of expensive toys","The materials you actually have"]$j$,
        3, $t$When the AI knows your real resources, it plans activities you can actually do.$t$),
    (m, 4, $t$Why should you ask the AI for a safety note with Grade R activities?$t$,
        $j$["Small objects can be swallowed and the AI may not mention it unless asked","Because safety notes make the plan longer","Because Grade R children do not play","Safety notes are only for high school"]$j$,
        0, $t$Young children can be hurt by small objects or rough games. Always ask for safety notes.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 3
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-r7';

    insert into public.modules (course_id, position, title, summary)
    values (c, 3, $t$Grades 1–3: reading and writing$t$,
            $t$Plan phonics, shared reading, group guided reading and writing activities for Home Language and First Additional Language.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Phonics and word lists$t$, 10, $md$
**In this lesson** you will use AI to plan phonics lessons and make word lists for the sounds you are teaching.

## Phonics in the Foundation Phase

**Phonics** means teaching the link between **sounds** and **letters**. Learners learn single sounds first (like *a*, *m*, *b*), then join them into syllables and words. In isiXhosa, learners build syllables like *ma*, *me*, *mi*, *mo*, *mu*, then words like *mama*. In English First Additional Language (FAL), learners learn sounds like *sh*, *ch* and *th*.

## Ask for a phonics lesson

> You are an experienced Grade 1 teacher. Plan a 15-minute English First Additional Language phonics lesson on the sound "sh". Include: a short warm-up song or chant, how to show the sound (mouth shape and action), 10 simple words with "sh" that a Grade 1 learner in a rural school will know, a quick game, and 2 sentences for reading together.

## Word lists — check every word

Ask for **many words**, then choose the best ones. The AI sometimes gives words that:

- do not have the sound in the right place
- are too difficult or unknown to young children
- are not common in South Africa (for example "sherbet" or "shilling")

## For isiXhosa phonics — be extra careful

AI tools often make mistakes in isiXhosa spelling and syllables. Use the AI for the **lesson structure** (warm-up, teaching, game, reading) and then make the isiXhosa word list **yourself**, or with your phase colleagues. You can write:

> Plan the structure of a 15-minute Grade 1 isiXhosa Home Language phonics lesson on the syllables "ba, be, bi, bo, bu". I will write the isiXhosa words myself. Give me the steps, a game and the timing.

## Key words

| Word | Simple meaning |
|---|---|
| Phonics | Teaching how letters and sounds go together |
| Syllable | A part of a word with one vowel sound, like "ma" in "mama" |
| FAL | First Additional Language — the second language a learner studies, often English |

**Remember:** The AI gives the plan. You choose and check the words.
$md$,
     $t$Pick the next sound or syllable you will teach. Ask the AI for a 15-minute phonics lesson and 15 example words. Cross out every word that is wrong, too hard or not familiar to your learners.$t$),

    (m, 2, $t$Shared reading and graded stories$t$, 12, $md$
**In this lesson** you will ask AI to write short reading texts at the right level for your learners, and plan shared and group guided reading.

## Learners need many short texts

Learners in Grades 1–3 need to read **a lot**. But many schools have few readers. AI can write **short, simple stories** for practice. You can write them on the chalkboard or on chart paper.

## Make the level clear

Tell the AI exactly how hard the text must be:

- the grade and the term
- how many words in total
- how many words in a sentence
- which sounds or **sight words** learners already know
- a topic learners know

> Write a short reading text for Grade 2 English First Additional Language learners in Term 3. Length: 60–80 words. Sentences of 5–8 words. Use mostly simple words and these sight words: the, is, a, we, go, to, see, my. Topic: a trip to the market in town with Gogo. After the story give 4 questions: 2 "find it in the text" questions and 2 "what do you think" questions.

## Shared reading over a week

Shared reading uses **one text for the whole week**. Ask the AI to plan the five days:

> Plan 5 days of shared reading (15 minutes a day) for Grade 3 using the text below. Day 1: predict and read. Day 2: new words. Day 3: re-read and questions. Day 4: a language point from the text. Day 5: a short writing activity. [Paste your text]

## Group guided reading

In group guided reading, you sit with **one small group at their level**. Ask the AI for **three versions** of the same story: easy, middle and harder. Each group reads the same story at its own level.

## Check the text

Read the text **aloud**. Is it natural? Are there words your learners will not know? Is the content fair and familiar? Change what does not fit.

## Key words

| Word | Simple meaning |
|---|---|
| Sight words | Common words learners know on sight without sounding out, like "the" |
| Shared reading | The teacher and the whole class read one big text together |
| Group guided reading | The teacher reads with a small group at the same level |

**Remember:** Tell the AI the level in numbers: words, sentence length and known words.
$md$,
     $t$Ask the AI for one story in three levels (easy, middle, harder) for your grade, on a topic your learners know. Check that each level really is different.$t$),

    (m, 3, $t$Writing activities and English vocabulary$t$, 10, $md$
**In this lesson** you will plan writing activities and English (FAL) vocabulary lessons with AI.

## Writing in small steps

Young learners write best with **support**. AI can help you make:

- **writing frames** — sentences with gaps, like "My name is ___. I like ___."
- **picture prompts** — a description of a picture you can draw on the board
- **word banks** — a list of useful words for the topic

> Make a writing frame for Grade 2 learners to write 4 sentences about "My favourite animal". Give the frame with gaps, a word bank of 12 animal and describing words, and an example of a finished piece of writing.

## Teaching English vocabulary

For FAL, learners need to **hear, say and use** new words many times. Ask the AI for activities that use **actions and objects**, not only writing:

> I am teaching Grade 1 English FAL. The theme is "Food". Give me 8 vocabulary words and 4 short activities: a song with actions, a "Simon says" game, a picture-matching game I can draw on the board, and a speaking activity in pairs.

## Use the home language as a bridge

Learners understand faster when you connect the English word to the **isiXhosa word they know**. You can ask the AI to plan *when* to use the home language, but **write the isiXhosa words yourself** — AI translations can be wrong.

> Plan a vocabulary lesson where I first say the word in isiXhosa, then teach it in English with an action. Leave a gap where I will write the isiXhosa word.

## Key words

| Word | Simple meaning |
|---|---|
| Writing frame | A model with gaps that helps learners write their own sentences |
| Word bank | A list of useful words on the board for learners to use |
| Vocabulary | The words a learner knows and uses |

**Remember:** Support first, then less support. Frames today, free writing later.
$md$,
     $t$Ask the AI for a writing frame and word bank for a topic your class is doing this term. Try it with your learners and notice who needs more support.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$The AI gives you 15 words for a phonics lesson. What should you do?$t$,
        $j$["Use all of them without reading","Check every word and remove words that are wrong or too hard","Ask the learners to check them","Only use the first word"]$j$,
        1, $t$AI word lists often contain mistakes or unfamiliar words. You choose the best ones.$t$),
    (m, 2, $t$How do you tell the AI the level of a reading text?$t$,
        $j$["Say \"make it easy\"","Say nothing; the AI knows","Give the grade, number of words, sentence length and known sight words","Ask for the longest story possible"]$j$,
        2, $t$Clear numbers help the AI write at exactly the right level.$t$),
    (m, 3, $t$What is a writing frame?$t$,
        $j$["A wooden board for writing","A model with gaps that helps learners write sentences","A test with no help","A list of spelling mistakes"]$j$,
        1, $t$A writing frame gives learners the structure, so they only fill in their own ideas.$t$),
    (m, 4, $t$Why is it good to get three versions of one story?$t$,
        $j$["So each reading group can read the same story at its own level","So the lesson takes three times longer","Because the AI cannot write one story","So the learners can copy it three times"]$j$,
        0, $t$Three levels let every group work on the same story at a level that suits them.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 4
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-r7';

    insert into public.modules (course_id, position, title, summary)
    values (c, 4, $t$Grades 1–3: Mathematics and Life Skills$t$,
            $t$Plan number work with concrete objects, daily mental maths, word problems from everyday life, and Life Skills lessons.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Number sense with objects and mental maths$t$, 10, $md$
**In this lesson** you will use AI to plan hands-on number lessons and short daily mental maths routines.

## Concrete, then pictures, then numbers

Young learners understand numbers best in three steps:

1. **Concrete** — counting real objects: bottle tops, stones, sticks
2. **Pictures** — drawings, dots, tally marks
3. **Numbers** — written sums like 7 + 5 = 12

Ask the AI to follow these steps in the lesson.

> Plan a 30-minute Grade 1 Mathematics lesson on "adding to 10". Follow three steps: first learners use bottle tops, then they draw dots, then they write number sentences. I have 45 learners in groups of 5. Give clear instructions for each step and 5 questions for each step.

## A daily mental maths routine

CAPS asks for **mental maths every day**: 10 minutes of quick counting and number facts. AI can make a different set every day so you do not repeat the same questions.

> Make 5 days of 10-minute mental maths for Grade 3, Term 2. Each day: counting forwards and backwards (in 3s, 4s or 5s), 10 quick number-fact questions, and one "number of the day" activity. Numbers up to 500. Give the answers separately.

## Check the numbers

The AI can make **calculation mistakes**. Always:

- work out the answers yourself, or check the answer list carefully
- check that the numbers stay inside the range for your grade and term
- check that the questions get harder slowly

## Key words

| Word | Simple meaning |
|---|---|
| Concrete objects | Real things learners can hold and count |
| Mental maths | Doing sums in your head, quickly, without writing |
| Number range | The smallest and biggest numbers used, e.g. 0 to 100 |

**Remember:** Objects first. And always check the AI's answers — it can count wrongly.
$md$,
     $t$Ask the AI for one week of mental maths for your grade and term. Check every answer. Did you find any mistakes?$t$),

    (m, 2, $t$Word problems from everyday life$t$, 10, $md$
**In this lesson** you will ask AI to write word problems that use your learners' own world.

## Why local problems help

A word problem about "buying apples at a supermarket in London" means little to a child in Lusikisiki. A problem about **a taxi, a spaza shop, chickens or the school garden** is easy to picture. When learners can picture it, they can solve it.

## Give the AI a setting

> Write 8 word problems for Grade 2 Mathematics, Term 3. Topic: addition and subtraction up to 99. Use everyday life in a village in the Eastern Cape: the spaza shop, taxis, chickens, the school garden, fetching water. Use short sentences and simple English. Problems 1–4 easy, 5–8 a little harder. Give the answers and the number sentence for each problem.

## Language matters

Many learners struggle with word problems because of the **language**, not the maths. Ask the AI to:

- use **short sentences** and **simple words**
- **repeat the same key words** (more, less, altogether, left)
- add a **picture idea** you can draw on the board

> Rewrite these problems with very simple English for learners who are still learning English. Underline the maths words: more, less, altogether, left, share.

## Money problems

South African money is rand (R) and cents (c). Ask for **real prices** that make sense (bread around R18, a cold drink around R12). Check: the AI may use old or strange prices, or dollars.

## Key words

| Word | Simple meaning |
|---|---|
| Word problem | A maths question written as a short story |
| Setting | Where the story happens |
| Number sentence | The sum written in numbers, e.g. 23 + 15 = 38 |

**Remember:** Familiar settings and simple English let learners see the maths.
$md$,
     $t$Ask the AI for 6 word problems for your grade using a setting your learners know. Check the prices, the language and the answers.$t$),

    (m, 3, $t$Planning Life Skills lessons$t$, 10, $md$
**In this lesson** you will use AI to plan Life Skills: Beginning Knowledge, Personal and Social Wellbeing, Creative Arts and Physical Education.

## Life Skills has four parts

In Grades 1–3, Life Skills includes:

- **Beginning Knowledge** — e.g. seasons, plants, my community
- **Personal and Social Wellbeing** — e.g. my feelings, safety, healthy habits
- **Creative Arts** — drawing, music, dance and drama
- **Physical Education (PE)** — games and movement

## Ask for a lesson that links the parts

> Plan a 45-minute Grade 2 Life Skills lesson on "Keeping my body healthy" (Personal and Social Wellbeing). Include: a short discussion with 4 questions, a song or movement activity, and a simple drawing activity. Use examples of healthy food that are cheap and common in the Eastern Cape, such as umngqusho, pap, cabbage, beans and fruit.

## PE without equipment

> Give me 5 PE games for 50 Grade 3 learners on a sand field. I have one ball and chalk. Each game must be safe and include everyone.

## Sensitive topics

Some topics — feelings, safety, family, abuse prevention, illness — need **care**. Use the AI for activity ideas and simple wording, but:

- check that the message matches **your school and department policies**
- think about learners who may have painful experiences at home
- know who to refer learners to if something comes up

## Key words

| Word | Simple meaning |
|---|---|
| Beginning Knowledge | Learning about the world: nature, community, time |
| Wellbeing | Being healthy and happy in body and mind |
| Sensitive topic | A subject that may upset some learners and needs care |

**Remember:** Life Skills should be active and caring. Check sensitive content against your school's policy.
$md$,
     $t$Ask the AI for a Life Skills lesson on a topic from your ATP this term, with one active part and one creative part. Mark anything you would change for your learners.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$What is the right order for teaching number concepts to young learners?$t$,
        $j$["Numbers, then pictures, then objects","Objects, then pictures, then numbers","Only written sums","Pictures only"]$j$,
        1, $t$Concrete objects first, then pictures, then written numbers.$t$),
    (m, 2, $t$Why should you check the AI's answers to maths questions?$t$,
        $j$["The AI is always right","The answers are not important","The AI can make calculation mistakes","Learners like wrong answers"]$j$,
        2, $t$AI tools can count or calculate wrongly. Check before you use the answers.$t$),
    (m, 3, $t$Which word problem setting is best for Grade 2 learners in a rural Eastern Cape school?$t$,
        $j$["A shopping trip in Paris","A ski holiday in the mountains","Buying shares at the stock exchange","Buying bread at the local spaza shop"]$j$,
        3, $t$Familiar settings help learners picture the problem and focus on the maths.$t$),
    (m, 4, $t$When planning a lesson on a sensitive Life Skills topic, what must you do?$t$,
        $j$["Check it against school policy and think about learners' experiences","Copy the AI answer exactly","Avoid all discussion","Ask learners to share private family problems with the class"]$j$,
        0, $t$Sensitive topics need care, the right policy and a plan for referrals.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 5
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-r7';

    insert into public.modules (course_id, position, title, summary)
    values (c, 5, $t$Grades 4–7: supporting learners in English$t$,
            $t$Help learners with the move to English as the language of teaching in Grade 4: vocabulary, reading comprehension and language structures.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$The Grade 4 jump: teaching in English$t$, 10, $md$
**In this lesson** you will use AI to prepare for one of the hardest moments in primary school: the change from isiXhosa to English as the language of teaching.

## Why Grade 4 is hard

In many Eastern Cape schools, learners learn in **isiXhosa** in Grades 1–3. In **Grade 4** they suddenly learn Maths, Science and Social Sciences in **English**. They must learn new subjects *and* a new language at the same time. Many fall behind here.

## Prepare subject words before the lesson

Before each new topic, find the **subject words** learners need. Ask the AI:

> I teach Grade 4 Natural Sciences and Technology in English. My learners' home language is isiXhosa and their English is still weak. The topic is "Plants: parts and their functions". List the 10 most important English words for this topic. For each word give: a very simple English meaning (under 10 words), a picture I can draw, and an action or real object I can show.

Then add the **isiXhosa word yourself**, or check it with a colleague. Make a **word wall** with both languages.

## Simplify, don't make it easier

Learners must still learn the full CAPS content. You make the **language** simpler, not the **science**. Ask:

> Rewrite this paragraph from the textbook in simple English for Grade 4 learners who are learning English. Keep all the science facts. Use short sentences. Explain difficult words in brackets. [paste paragraph]

## Plan talk in both languages

Learners can **discuss in isiXhosa** in groups and then **report back in English**. This is called **translanguaging**. Ask the AI to plan these steps into your lesson.

## Key words

| Word | Simple meaning |
|---|---|
| Subject words | Special words used in a subject, e.g. "photosynthesis", "fraction" |
| Word wall | A wall chart of important words for the topic |
| Translanguaging | Using both languages on purpose to help learners understand |

**Remember:** Make the language simpler, not the content. Teach the subject words first.
$md$,
     $t$Choose your next Grade 4–7 topic in any subject. Ask the AI for the 10 key English words with simple meanings and picture ideas. Add the isiXhosa words yourself and make a word wall.$t$),

    (m, 2, $t$Reading comprehension at the right level$t$, 12, $md$
**In this lesson** you will ask AI to write comprehension texts and questions for Grades 4–7 at different levels of thinking.

## Ask for a text that fits your learners

Tell the AI the grade, whether it is Home Language or First Additional Language, the length and the topic.

> Write a 200-word reading text for Grade 5 English First Additional Language. Topic: a girl from Port St Johns who starts a vegetable garden at school. Use mostly short sentences and common words. Then write 8 questions: 3 about facts in the text, 3 that need learners to think and explain, and 2 that ask for their own opinion. Give a short memo.

## Three types of questions

Good comprehension has **different kinds of questions**:

| Type | What learners do | Example |
|---|---|---|
| **Literal** | Find the answer in the text | "Where does Zintle live?" |
| **Inferential** | Read between the lines | "Why do you think Zintle was tired?" |
| **Evaluative** | Give an opinion with a reason | "Was it a good idea to start the garden? Why?" |

If the AI gives only "find it" questions, ask: *"Add 3 inferential and 2 evaluative questions."*

## Use texts you already have

You can paste a text from your **textbook or reader** and ask the AI for questions only. This saves time and keeps the text at the level the department chose.

> Here is a text from our Grade 6 reader. Write 6 comprehension questions (2 literal, 2 inferential, 2 evaluative) and a memo. [paste text]

## Check facts in the text

If the AI writes about a real place, person or event, **check the facts**. The AI may invent details — for example, a wrong date or a river that does not exist.

## Key words

| Word | Simple meaning |
|---|---|
| Comprehension | Understanding what you read |
| Literal question | The answer is written in the text |
| Inferential question | Learners must work out the answer from clues |

**Remember:** Ask for a mix: find it, think about it, and give your opinion.
$md$,
     $t$Paste a short text from your textbook into the AI. Ask for 2 literal, 2 inferential and 2 evaluative questions with a memo. Check that each question is the right type.$t$),

    (m, 3, $t$Language structures and writing tasks$t$, 10, $md$
**In this lesson** you will use AI to teach grammar (language structures and conventions) and plan writing tasks for Grades 4–7.

## Teach grammar in context

CAPS asks you to teach **language structures** — like tenses, pronouns or punctuation — inside real texts, not as lists of rules. Ask the AI to connect the grammar to the week's text or theme.

> I teach Grade 6 English FAL. This week's theme is "Sport". Plan a 30-minute lesson on the simple past tense. Start with a short text about a school soccer match that uses the past tense. Then give a simple explanation, 10 practice sentences (from easy to harder) and a short pair activity. Include a memo.

## Common mistakes

Ask the AI what mistakes learners often make, so you can plan for them:

> What mistakes do isiXhosa-speaking learners often make with English pronouns (he/she) and plurals? Give 5 examples and a quick activity for each.

Check this against what **you** see in your learners' books. You know your class best.

## Planning a writing task

For a writing task (a letter, a story, a report), ask for:

- the **task** in simple words for learners
- a **planning frame** (beginning, middle, end)
- a **model text** at the right level
- a simple **rubric** with 3 or 4 criteria

> Plan a Grade 7 writing task: a friendly letter to a cousin about a school trip. Give the learner instructions, a planning frame, a 120-word model letter, and a rubric out of 20 with 4 criteria.

## Key words

| Word | Simple meaning |
|---|---|
| Language structures | Grammar: how words and sentences are built |
| In context | Inside a real text or situation, not alone |
| Model text | A good example that shows learners what to write |

**Remember:** Grammar sticks better when it lives in a real text.
$md$,
     $t$Ask the AI for a 30-minute grammar lesson linked to your current theme. Check the practice sentences and the memo for mistakes.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$Why is Grade 4 hard for many Eastern Cape learners?$t$,
        $j$["They get a new school uniform","They often start learning subjects in English instead of isiXhosa","There is no Mathematics in Grade 4","They only learn in isiXhosa"]$j$,
        1, $t$Many learners switch to English as the language of teaching in Grade 4, while learning new content.$t$),
    (m, 2, $t$When you ask the AI to simplify a textbook paragraph, what should stay the same?$t$,
        $j$["The difficult words","The long sentences","The subject facts","Nothing should stay"]$j$,
        2, $t$Make the language simpler, but keep the full CAPS content.$t$),
    (m, 3, $t$"Why do you think Zintle was tired?" is an example of which question type?$t$,
        $j$["Literal","Spelling","Evaluative","Inferential"]$j$,
        3, $t$Learners must use clues in the text to work out the answer — that is an inferential question.$t$),
    (m, 4, $t$What is the best way to teach grammar according to this lesson?$t$,
        $j$["Inside a real text or theme","As a long list of rules only","Never teach grammar","Only in the last week of the year"]$j$,
        0, $t$Grammar is easier to understand and remember when it is taught in context.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 6
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-r7';

    insert into public.modules (course_id, position, title, summary)
    values (c, 6, $t$Grades 4–7: Mathematics$t$,
            $t$Explain concepts step by step, make practice at three levels, and find and fix common mistakes.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Explaining a concept step by step$t$, 10, $md$
**In this lesson** you will ask AI for clear, step-by-step explanations of maths concepts, with real-life examples.

## Ask for small steps

Many learners get lost when a teacher jumps from step 2 to step 5. Ask the AI to break the concept into **small steps** and to use **objects or drawings**.

> I teach Grade 4 Mathematics. Explain "equivalent fractions" in 6 small steps that I can teach on the chalkboard. Start with a real object (folding paper or sharing a loaf of bread). Use drawings I can make on the board. Use simple English for learners whose home language is isiXhosa. End with 5 questions to check understanding.

## Ask for different explanations

If learners do not understand the first explanation, you need **another way**. Ask:

> Give me 3 different ways to explain equivalent fractions: one with a drawing, one with objects, and one with a story.

## Check the maths

Read every step. Ask yourself:

- Is each step **correct**?
- Does it use the **same method and words** as the CAPS textbook your learners use?
- Is anything **missing**?

Learners get confused if a new explanation uses a different method from the textbook. You can tell the AI: *"Use the method in the textbook: [describe it]."*

## Grade 7 — Senior Phase

Grade 7 learners start more formal algebra, integers and exponents. The same method works: small steps, concrete examples (like temperature for negative numbers), and many checks for understanding.

## Key words

| Word | Simple meaning |
|---|---|
| Concept | An idea learners must understand, e.g. "fraction" |
| Equivalent fractions | Fractions that look different but are the same size, e.g. ½ and 2/4 |
| Check for understanding | A quick question to see if learners understood |

**Remember:** Small steps, real objects, and the same method as the textbook.
$md$,
     $t$Choose a concept learners find hard in your grade. Ask the AI to explain it in small steps with a real-life example. Then ask for 2 other ways to explain it.$t$),

    (m, 2, $t$Practice worksheets at three levels$t$, 10, $md$
**In this lesson** you will use AI to make practice exercises that suit learners who struggle, learners at grade level and learners who are ahead.

## One class, many levels

In a class of 50, some learners need **more practice with basics** and some need a **challenge**. The AI can make three versions of the same exercise in a minute.

> Make a practice worksheet for Grade 5 Mathematics on "multiplying 2-digit numbers by 1-digit numbers". Make three sections: Level 1 (8 questions with smaller numbers and a worked example), Level 2 (8 grade-level questions), Level 3 (4 word problems that need two steps). Use South African contexts and rand. Give a memo with workings.

## No photocopier? No problem

If you cannot print, ask for a version you can **write on the board**:

> Format this worksheet so it fits on a chalkboard: short questions, numbered, no tables or pictures.

Learners can copy only their own level into their books.

## Check the memo — every time

The AI often makes mistakes in **long calculations** and **multi-step problems**. Work out at least some answers yourself. If you find one mistake, check all of them.

## Use the levels well

- Let learners **move up a level** when they are ready.
- Don't label groups in a way that makes learners feel bad. Use colours or animal names instead of "weak" and "strong".

## Key words

| Word | Simple meaning |
|---|---|
| Level | How difficult the work is |
| Worked example | A question that is solved step by step to show the method |
| Memo | The answers (and workings) for the teacher |

**Remember:** Three levels, one topic — and check the memo yourself.
$md$,
     $t$Ask the AI for a three-level worksheet on this week's maths topic, formatted for the chalkboard. Check five answers in the memo yourself.$t$),

    (m, 3, $t$Finding and fixing common mistakes$t$, 10, $md$
**In this lesson** you will use AI to plan for the mistakes learners often make, so you can prevent and fix them.

## Mistakes show thinking

When a learner makes the same mistake again and again, there is usually a **misconception** — a wrong idea behind it. For example, a learner who says 0.25 is bigger than 0.5 may think "25 is bigger than 5, so 0.25 is bigger".

## Ask the AI about misconceptions

> I teach Grade 6 Mathematics. List the 5 most common misconceptions learners have about decimal fractions. For each one give: an example of the wrong answer, the wrong idea behind it, and a quick activity (5 minutes) to fix it.

## Use your learners' real mistakes

The best information comes from **your learners' books**. Look at a set of books and write down the mistakes you see — **without names**. Then ask:

> In a Grade 5 test, many learners wrote 34 + 18 = 412. What wrong idea do they have? Give me a short re-teaching activity with place value blocks or bundles of sticks.

## Plan a short re-teaching lesson

> Plan a 20-minute re-teaching lesson for learners who think that multiplying always makes a number bigger. Use examples with fractions. Include 6 practice questions and an exit question.

## Key words

| Word | Simple meaning |
|---|---|
| Misconception | A wrong idea that causes the same mistake many times |
| Re-teaching | Teaching a part of the work again in a new way |
| Place value | The value of a digit because of its place, e.g. the 3 in 34 means 30 |

**Remember:** A mistake is a clue. Find the wrong idea, then teach to fix it.
$md$,
     $t$Look at your learners' last maths work. Write down one common mistake (no names). Ask the AI what wrong idea causes it and for a 10-minute activity to fix it.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$Why should the AI's explanation use the same method as your learners' textbook?$t$,
        $j$["Different methods can confuse learners","The AI does not know other methods","Textbooks are always wrong","It makes the lesson longer"]$j$,
        0, $t$When the method matches the textbook, learners are not confused by two different ways at once.$t$),
    (m, 2, $t$What is a good way to give learners work at different levels?$t$,
        $j$["Give everyone only the hardest questions","Ask the AI for three levels of the same topic","Give struggling learners no work","Give only one question"]$j$,
        1, $t$Three levels on one topic let every learner practise at the right level.$t$),
    (m, 3, $t$A learner thinks 0.25 is bigger than 0.5. What is this?$t$,
        $j$["A spelling error","A good answer","A misconception","A memo"]$j$,
        2, $t$It is a misconception: the learner compares 25 and 5 as whole numbers.$t$),
    (m, 4, $t$The AI gives a memo for a multi-step worksheet. What should you do?$t$,
        $j$["Trust all answers","Give the memo to learners without looking","Delete the memo","Work out some answers yourself and check them"]$j$,
        3, $t$AI often makes mistakes in long calculations. Always check the memo.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 7
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-r7';

    insert into public.modules (course_id, position, title, summary)
    values (c, 7, $t$Grades 4–7: Sciences and Social Sciences$t$,
            $t$Plan safe, low-cost experiments, Technology projects, and History and Geography lessons with checked facts and local examples.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Simple experiments with cheap materials$t$, 10, $md$
**In this lesson** you will ask AI to plan Natural Sciences investigations that you can do without a laboratory.

## Science is doing

Learners understand science better when they **observe, predict and test**. You do not need a lab. Many investigations work with **bottles, cups, water, soil, seeds, salt, string and plastic bags**.

> I teach Grade 5 Natural Sciences and Technology. Topic: "Plants need water and light to grow." Plan a simple investigation using cheap materials (bean seeds, cups or cut bottles, soil, water). Give: the question, what learners predict, materials, steps, what to observe each day for 10 days, a simple results table, and the conclusion. Add safety notes.

## Ask for a fair test

A good investigation changes **only one thing** at a time. Ask the AI to explain this clearly:

> Explain to Grade 6 learners, in simple English, what a fair test is, using the plant investigation as the example.

## Safety first

Always ask for **safety notes**, and read them carefully. Be very careful with:

- heat, fire and candles
- chemicals (including household cleaners)
- glass and sharp objects

If the AI suggests something dangerous, **do not use it**. You are responsible for learner safety.

## Check the science

The AI can mix up facts or give results that would not really happen. Try the experiment **yourself first** if you can. Check facts against the **CAPS-approved textbook**.

## Key words

| Word | Simple meaning |
|---|---|
| Investigation | A way to find an answer by testing and observing |
| Predict | Say what you think will happen before you test |
| Fair test | A test where you change only one thing |

**Remember:** Try it yourself first, check the safety notes, and check the facts.
$md$,
     $t$Ask the AI for a low-cost investigation for your next Natural Sciences topic. Read the safety notes. Is there anything you would not allow in your class?$t$),

    (m, 2, $t$History and Geography with checked facts$t$, 12, $md$
**In this lesson** you will plan Social Sciences lessons with AI — and learn why facts must always be checked.

## The AI can invent history

AI tools sometimes **make up facts**: wrong dates, people who never existed, events that did not happen. This is called **hallucination**. In History and Geography, this is a serious problem. Your learners will believe what you teach.

## Use AI for the lesson, the textbook for the facts

A safe method:

1. Take the **facts from your textbook** or another trusted source.
2. Paste them into the prompt.
3. Ask the AI to turn them into **activities**.

> Here are the facts from our Grade 5 Social Sciences textbook about the San hunter-gatherers: [paste facts]. Using ONLY these facts, plan a 45-minute lesson with: a picture discussion, a role-play activity, and 6 questions. Do not add any new facts.

## Local history and geography

Learners are more interested in **their own area**. You can ask for activities about Eastern Cape places such as rivers, towns, the Wild Coast, or the history of local people. But **check every fact** — the AI knows less about small places, and is more likely to make mistakes.

> Plan a Grade 4 Geography map-skills lesson where learners draw a simple map of the way from their home to school. Include a key, symbols and the four compass directions. Use examples of what they might see in a rural village.

## Sources and different views

In History, learners must learn to look at **sources** and **different points of view**. Ask the AI for questions like: *"Who wrote this? Why? What might another person say?"*

## Key words

| Word | Simple meaning |
|---|---|
| Hallucination | When the AI makes up information that is not true |
| Source | Where information comes from: a book, letter, photo or person |
| Trusted source | A source you can rely on, like your CAPS textbook |

**Remember:** In Social Sciences, the facts come from your textbook. The AI only helps with activities.
$md$,
     $t$Copy 5 facts from your Social Sciences textbook. Ask the AI to plan activities using ONLY those facts. Check that it did not add anything new.$t$),

    (m, 3, $t$Technology projects and the design process$t$, 10, $md$
**In this lesson** you will use AI to plan Technology projects that follow the design process.

## The design process

In Technology, learners solve problems by following steps:

1. **Investigate** — understand the problem
2. **Design** — draw ideas
3. **Make** — build a model
4. **Evaluate** — test it and say how to improve it
5. **Communicate** — show and explain their work

## Ask for a project with a local problem

Real problems make projects meaningful.

> Plan a Grade 6 Technology project on structures. The problem: learners in a village must cross a small stream to get to school after rain. Learners must design and build a model bridge from newspaper, string, sticks and glue that can hold a tin of beans. Follow the design process. Give a brief, a 4-week plan (2 lessons per week), a materials list and a simple rubric.

## Group work and roles

Projects work well in groups of 4 or 5. Ask the AI to suggest **group roles** (designer, builder, tester, reporter) so every learner has a job.

## Assessment

Ask the AI for a **rubric** that matches the design process steps. Check that the rubric marks the **thinking**, not only how nice the model looks.

## Key words

| Word | Simple meaning |
|---|---|
| Design process | The steps for solving a problem: investigate, design, make, evaluate, communicate |
| Brief | A short statement of the problem and what must be made |
| Evaluate | Test and judge how well something works |

**Remember:** A real, local problem makes Technology come alive.
$md$,
     $t$Think of a real problem in your community. Ask the AI to turn it into a Technology project brief for your grade with a materials list of free or cheap items.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$What is a fair test in a science investigation?$t$,
        $j$["A test that every learner passes","A test where you change only one thing","A test with no results","A test done only by the teacher"]$j$,
        1, $t$In a fair test you change only one thing, so you know what caused the result.$t$),
    (m, 2, $t$What does "hallucination" mean when we talk about AI?$t$,
        $j$["The AI makes up information that is not true","The AI is very slow","The AI draws pictures","The AI refuses to answer"]$j$,
        0, $t$AI can invent facts, dates and people. Always check facts in Social Sciences.$t$),
    (m, 3, $t$What is the safest way to use AI for a History lesson?$t$,
        $j$["Let the AI choose the facts","Use any facts the AI gives","Do not use a textbook","Paste facts from your textbook and ask the AI for activities only"]$j$,
        3, $t$Take facts from a trusted source and let the AI only design the activities.$t$),
    (m, 4, $t$The AI suggests an experiment that uses fire. What should you do?$t$,
        $j$["Do it without checking","Let learners do it alone","Check the safety carefully, and do not use it if it is dangerous","Ask learners to try it at home"]$j$,
        2, $t$You are responsible for safety. Never use an activity you think is dangerous.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 8
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-r7';

    insert into public.modules (course_id, position, title, summary)
    values (c, 8, $t$Planning a full lesson from start to end$t$,
            $t$Write clear lesson aims, strong openings, active middles for big classes, and endings that check learning.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Lesson aims and a strong start$t$, 10, $md$
**In this lesson** you will use AI to write clear lesson aims and plan the first 5 minutes of a lesson.

## A clear aim

A **lesson aim** (or objective) says what learners will be able to do **by the end of the lesson**. A good aim uses an action word:

- "Learners will be able to **name** the parts of a plant."
- "Learners will be able to **add** 2-digit numbers with carrying."
- "Learners will be able to **write** 3 sentences in the past tense."

Weak aims say "Learners will **understand**…" or "Learners will **learn about**…". You cannot see understanding — you can see naming, adding and writing.

> Rewrite these lesson aims so that each uses an action word I can observe and check: "Learners will understand fractions." "Learners will know about the water cycle."

## The first 5 minutes

The start of the lesson must **wake learners up** and **connect** to what they already know. Ask the AI for ideas:

> Give me 5 different ways to start a Grade 4 lesson on "The water cycle". Each start must take 5 minutes or less, use no special equipment, and connect to learners' daily life (rain, rivers, fetching water).

Good starts include: a question, a picture on the board, a short story, an object, a quick game, or a problem to solve.

## Link to the last lesson

Ask the AI for 3 **quick revision questions** from yesterday's lesson. This helps learners remember, and shows you who needs help.

## Key words

| Word | Simple meaning |
|---|---|
| Lesson aim | What learners will be able to do by the end of the lesson |
| Action word | A verb you can see: name, write, add, explain, draw |
| Revision | Going over work that was taught before |

**Remember:** Start with a clear aim and a short, interesting start.
$md$,
     $t$Write the aim for your next lesson. Ask the AI to check if it uses an action word you can observe. Then ask for 3 ways to start the lesson in 5 minutes.$t$),

    (m, 2, $t$Active learning in big classes$t$, 12, $md$
**In this lesson** you will plan the main part of a lesson so that all learners take part, even in a class of 50 or more.

## Big classes need structure

With many learners, the teacher often talks and learners only listen. But learners learn more when they **do, talk and think**. The AI can help you plan activities that work with big numbers.

> I have 55 Grade 6 learners in a small classroom with desks in rows. Give me 6 active learning methods that work in this space without moving the desks much. For each: the name, how it works in 3 steps, how long it takes, and an example for the topic "Food chains".

## Methods that work well

- **Think–pair–share** — think alone, talk to a partner, then some pairs share with the class
- **Number heads** — groups of 4 each number 1–4; you call a number to answer
- **Show me boards** — learners write answers on scrap paper or slates and hold them up
- **Stand up / sit down** — stand if you agree, sit if you disagree
- **Group stations** — different groups do different tasks, then swap

## Plan clear instructions

Many activities fail because instructions are unclear. Ask:

> Write the instructions for this group activity in 4 short steps that I can write on the board. Use simple English.

## Plan the timing

Ask the AI to give **times** for every part. A 45-minute lesson might be: 5 minutes start, 10 minutes teaching, 20 minutes activity, 10 minutes ending. If the plan is too full, ask: *"This is too much for 45 minutes. Remove what is least important."*

## Key words

| Word | Simple meaning |
|---|---|
| Active learning | Learners do, talk and think — not only listen |
| Think–pair–share | Think alone, talk with a partner, then share with the class |
| Timing | How many minutes each part of the lesson takes |

**Remember:** Every learner should do something, not only listen.
$md$,
     $t$Ask the AI for 3 active learning methods for your next lesson that work with your class size and room. Choose one and try it this week.$t$),

    (m, 3, $t$Ending the lesson and checking learning$t$, 10, $md$
**In this lesson** you will plan strong lesson endings that show you who understood and who needs help.

## Don't let the bell end the lesson

Many lessons simply stop when the bell rings. A planned ending helps learners **remember** the lesson and helps **you** know what to do tomorrow.

## Quick ways to check learning

Ask the AI for **exit tickets** — 1 to 3 short questions learners answer at the end of the lesson.

> Write 3 exit-ticket questions for a Grade 4 lesson on "Equivalent fractions": one easy, one medium, and one that needs explaining. They must take 3 minutes to answer and be quick to mark.

Other ideas:

- **Thumbs up / sideways / down** for "I understand"
- **3-2-1** — 3 things I learned, 2 questions I have, 1 thing I liked
- **One-sentence summary** — "Today I learned that…"

## Homework that makes sense

Homework should **practise** what was taught, not teach something new. Many learners have no help or no light at home. Ask the AI:

> Suggest 3 short homework tasks (15 minutes or less) that practise today's lesson and do not need a computer, internet or a parent who reads English.

## Plan for tomorrow

After the lesson, write down (no names) what learners struggled with. Tell the AI:

> Most learners could do question 1 and 2 of the exit ticket but not question 3. Plan a 10-minute start for tomorrow's lesson to fix this.

## Key words

| Word | Simple meaning |
|---|---|
| Exit ticket | Short questions learners answer before leaving the lesson |
| Consolidation | Bringing together and strengthening what was learned |
| Homework | Practice work done at home |

**Remember:** Check learning at the end. Use what you see to plan tomorrow.
$md$,
     $t$Ask the AI for 3 exit-ticket questions for your next lesson. Use them, then tell the AI what learners got wrong and ask for a 10-minute fix for the next day.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$Which lesson aim is the best?$t$,
        $j$["Learners will understand fractions","Learners will learn about plants","Learners will be able to name the parts of a plant","Learners will enjoy the lesson"]$j$,
        2, $t$A good aim uses an action word you can see and check, like "name".$t$),
    (m, 2, $t$What is "think–pair–share"?$t$,
        $j$["Learners think alone, talk to a partner, then share with the class","The teacher talks for the whole lesson","Learners copy from the board","Learners take a test in pairs"]$j$,
        0, $t$Think–pair–share gets every learner thinking and talking, even in a big class.$t$),
    (m, 3, $t$What is an exit ticket?$t$,
        $j$["A note to leave school early","A long test at the end of the term","Homework for the weekend","Short questions learners answer at the end of the lesson"]$j$,
        3, $t$Exit tickets quickly show you who understood the lesson.$t$),
    (m, 4, $t$What makes good homework for most learners in rural schools?$t$,
        $j$["Research on the internet","Short practice tasks that need no computer or reading help from parents","A new topic learners must teach themselves","Typing a long essay"]$j$,
        1, $t$Homework should practise today's lesson and be possible for every learner at home.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 9
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-r7';

    insert into public.modules (course_id, position, title, summary)
    values (c, 9, $t$Different learners, one classroom$t$,
            $t$Plan for multi-grade classes, learners who need extra support or extra challenge, and schools with very few resources.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$Multi-grade classes$t$, 12, $md$
**In this lesson** you will use AI to plan lessons when you teach two or more grades in one classroom.

## Common in the Eastern Cape

Many small rural schools have **multi-grade classes**: for example Grade 1 and 2 together, or Grades 4, 5 and 6 together. The teacher must cover **different CAPS content for each grade** in the same time. This is one of the hardest jobs in teaching.

## Find a shared theme

Often you can teach **one theme to all grades** and then give each grade its own task at its own level.

> I teach a multi-grade class: Grade 4 (18 learners) and Grade 5 (22 learners), Natural Sciences and Technology, Term 1. Grade 4 ATP topic: "Living and non-living things". Grade 5 ATP topic: "Plants and animals on Earth". Plan a 60-minute lesson with a shared introduction for both grades (10 minutes), then separate tasks for each grade, and a shared ending. Show what the teacher does in each part, and what each grade does while the teacher works with the other grade.

## Plan the teacher's time

The key question in multi-grade teaching is: **"What is each group doing while I teach the other group?"** Ask the AI to make a **timeline table**:

| Time | Grade 4 | Grade 5 | Teacher |
|---|---|---|---|
| 0–10 min | Shared start | Shared start | Teaches everyone |
| 10–25 min | Group task | Teacher-led lesson | With Grade 5 |
| 25–40 min | Teacher-led lesson | Independent task | With Grade 4 |

## Independent work must be clear

Learners working alone need **very clear, short instructions** and work they can do without help. Ask: *"Make the Grade 5 task something learners can do without the teacher for 15 minutes."*

## Key words

| Word | Simple meaning |
|---|---|
| Multi-grade class | One class with learners from two or more grades |
| Shared theme | One topic that all grades learn about at their own level |
| Independent work | Work learners do on their own, without the teacher |

**Remember:** In multi-grade planning, always ask: what is each grade doing at every moment?
$md$,
     $t$If you teach a multi-grade class (or imagine one), ask the AI for a 60-minute plan with a timeline table that shows what each grade and the teacher do at each time.$t$),

    (m, 2, $t$Learners who need support or challenge$t$, 10, $md$
**In this lesson** you will use AI to adapt lessons for learners who struggle and learners who are ahead — without sharing private information.

## Every class is mixed

Some learners struggle with reading. Some have trouble seeing or hearing. Some finish everything quickly and get bored. CAPS and the **SIAS** policy ask teachers to **support all learners** in the class.

## Describe needs without names

Never type a learner's name, diagnosis or family situation. Describe the **need** only:

> I have 3 learners in Grade 3 who cannot yet read 3-letter words, and 4 learners who finish all work quickly. Today's lesson is a reading lesson on the story "The Lost Goat". Suggest: 3 ways to support the learners who struggle with reading, and 3 extension activities for the fast learners. All activities must happen in the same classroom at the same time.

## Ideas the AI can help with

For learners who need **support**:
- shorter tasks, bigger print, pictures, a word bank
- working with a reading buddy
- more time and step-by-step instructions

For learners who need **challenge**:
- "why" and "what if" questions
- a harder version of the same task
- helping to explain to others (peer tutoring)

## Know when to ask for help

The AI can give **classroom ideas**. It cannot diagnose a learner. If you think a learner has a serious barrier to learning, follow your school's **SIAS** process and talk to the **School-Based Support Team (SBST)**.

## Key words

| Word | Simple meaning |
|---|---|
| Barrier to learning | Something that makes learning harder for a learner |
| Extension activity | Extra, harder work for learners who finish early |
| SIAS | Screening, Identification, Assessment and Support — the policy for supporting learners |

**Remember:** Describe the need, never the learner. The AI gives ideas; it does not diagnose.
$md$,
     $t$Think of the learners who struggle and the learners who are ahead in one of your lessons. Without names, ask the AI for 3 support ideas and 3 extension ideas for that lesson.$t$),

    (m, 3, $t$Teaching with few resources$t$, 10, $md$
**In this lesson** you will use AI to plan good lessons when you have no photocopier, few textbooks, no electricity or no internet in class.

## Tell the AI your real situation

The AI often assumes you have printers, projectors and the internet. You must tell it what you **do not** have.

> I teach Grade 5 in a rural school. I have a chalkboard, chalk, one textbook for every 3 learners, no photocopier, no electricity in class, and no internet. Plan a 45-minute Mathematics lesson on "measuring length" using only what I have and things from outside (sticks, string, stones, learners' own hands and feet).

## The chalkboard is a powerful tool

Ask the AI to **plan your board**:

> Show how to divide my chalkboard into 3 parts for this lesson: new words, worked example, and learner tasks. Keep the writing short so it fits.

## Prepare at home, use offline

Many teachers have the internet **on their phone at home**, but not in class. So:

1. Plan the lesson with AI at home.
2. Write the plan in your **planning book** or save it on your phone.
3. Teach from your notes — no internet needed in class.

Ask the AI to keep plans **short**, so they are easy to copy into a book.

## Use the environment

The school yard, the garden, the community, local plants and animals, and learners' own experiences are all **free resources**. Ask: *"How can I use the school yard to teach this topic?"*

## Key words

| Word | Simple meaning |
|---|---|
| Offline | Without internet |
| Environment | The world around the school: yard, garden, village |
| Planning book | The book where you write your lesson plans |

**Remember:** Tell the AI what you do *not* have, and plan at home so you can teach offline.
$md$,
     $t$Write a list of what you do and do not have in your classroom. Ask the AI for a lesson that uses only what you have, plus a plan for your chalkboard.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$What is the key question in multi-grade planning?$t$,
        $j$["Which grade is the best?","What is each grade doing while I work with the other grade?","How can I teach only one grade?","How long is break time?"]$j$,
        1, $t$Every grade must have meaningful work at every moment, even when the teacher is busy with another grade.$t$),
    (m, 2, $t$How should you describe a learner who struggles when you write a prompt?$t$,
        $j$["With full name and surname","With the learner's ID number","Describe the need only, e.g. \"3 learners cannot yet read 3-letter words\"","With the learner's home address"]$j$,
        2, $t$Describe the need, never the learner. Personal information must stay private.$t$),
    (m, 3, $t$The AI suggests you show a video on a projector, but you have no electricity. What should you do?$t$,
        $j$["Cancel the lesson","Buy a projector","Use the plan anyway","Tell the AI what you have and ask for a new plan"]$j$,
        3, $t$Tell the AI your real resources, and it will plan a lesson you can teach.$t$),
    (m, 4, $t$You think a learner has a serious barrier to learning. What should you do?$t$,
        $j$["Follow the SIAS process and talk to the School-Based Support Team","Ask the AI to diagnose the learner","Ignore it","Type the learner's details into the AI"]$j$,
        0, $t$AI cannot diagnose learners. Use your school's SIAS process and the SBST.$t$);
end
$seed$;

------------------------------------------------------------------
-- MODULE 10
------------------------------------------------------------------
do $seed$
declare c uuid; m uuid;
begin
    select id into c from public.courses where slug = 'lesson-prep-r7';

    insert into public.modules (course_id, position, title, summary)
    values (c, 10, $t$Weekly planning, checking and your toolkit$t$,
            $t$Turn the ATP into weekly plans, check every AI plan with a simple checklist, and build a planning toolkit to share with your phase.$t$)
    returning id into m;

    insert into public.lessons (module_id, position, title, minutes, content_md, practice_task) values
    (m, 1, $t$From the ATP to a weekly plan$t$, 10, $md$
**In this lesson** you will use AI to turn one week of your ATP into a plan for every day.

## Plan the week, then the lessons

Planning one lesson at a time takes long. It is faster to plan **the whole week** first and then fill in each lesson.

> I teach Grade 3 Mathematics. Term 2, Week 6. The ATP for this week says: [paste the ATP text]. Mathematics is 7 hours a week (about 1 hour a day, plus mental maths). Make a weekly plan in a table: Day, Lesson aim, Main activity, Resources, Homework. Monday introduces the skill and Friday is for consolidation and a short informal assessment.

## Check the weekly plan against the ATP

Look at the table. Does it:

- cover **everything** in the ATP for that week?
- leave out anything that is **not** in the ATP?
- have a sensible **order** — easy to hard?
- include **mental maths** (or reading routines, for languages) every day?

## Plan across subjects

Foundation Phase teachers teach Home Language, FAL, Mathematics and Life Skills. Ask the AI to **link subjects** where it makes sense:

> My Life Skills theme this week is "Water". Suggest one Home Language activity and one Mathematics activity that connect to this theme.

## Save time next year

Save your weekly plans in one place (a notebook, a folder on your phone, or a shared folder with your phase). Next year you can **reuse and improve** them instead of starting again.

## Key words

| Word | Simple meaning |
|---|---|
| Weekly plan | A plan that shows what you will teach each day of one week |
| Consolidation | Revising and practising to make learning strong |
| Informal assessment | A quick check of learning that is not for formal marks |

**Remember:** Plan the week from the ATP first. Then plan each lesson.
$md$,
     $t$Take next week's ATP for one subject. Ask the AI for a weekly plan table. Check that it covers everything in the ATP and nothing extra.$t$),

    (m, 2, $t$Checking and improving the AI's plan$t$, 12, $md$
**In this lesson** you will learn a simple checklist for every AI lesson plan, and how to ask the AI to improve it.

## The CHECK list

Before you use any AI plan, check these five things:

| Letter | Check | Question to ask yourself |
|---|---|---|
| **C** | CAPS | Does it match the CAPS topic and ATP for this week? |
| **H** | Honest facts | Are all facts, numbers and answers correct? |
| **E** | Easy to follow | Is the level and language right for my learners? |
| **C** | Culture and context | Are names, places and examples familiar and respectful? |
| **K** | Kit | Do I have the resources and the time? |

## Improve with follow-up prompts

Do not start again. Tell the AI **exactly what to change**:

- *"The language is too difficult for Grade 4 FAL learners. Use shorter sentences."*
- *"This plan is 60 minutes, but my lesson is 30 minutes. Shorten it."*
- *"Replace the internet research activity. My learners have no internet."*
- *"The names are all American. Use South African names."*
- *"Question 4 in the memo is wrong. Check all the answers again."*

## Ask the AI to check itself — but still check

You can ask: *"Check this plan against the CHECK list and tell me what to improve."* This often finds problems. But the AI can also **miss its own mistakes**. Your check is the final one.

## Keep a record

When you find a mistake the AI often makes (for example, wrong prices or wrong term topics), **add a line to your template** to prevent it: *"Use 2026 South African prices."*

## Key words

| Word | Simple meaning |
|---|---|
| Checklist | A list of things to check, one by one |
| Follow-up prompt | A new message that asks the AI to change its last answer |
| Respectful | Treating all people and cultures fairly and with care |

**Remember:** C-H-E-C-K every plan. Then ask for exactly what you want changed.
$md$,
     $t$Take an AI lesson plan you made in this course. Check it with the CHECK list. Write 2 follow-up prompts to fix what you found.$t$),

    (m, 3, $t$Your planning toolkit and working with colleagues$t$, 10, $md$
**In this lesson** you will build a set of saved prompts for lesson planning, and share it with your phase.

## Build your toolkit

A **toolkit** is a small set of prompts that you use again and again. Save them in a notebook, a note on your phone, or a WhatsApp message to yourself. A good Grade R–7 toolkit has:

1. **Lesson plan template** — the RTCF recipe from Module 1
2. **Weekly plan template** — from the ATP to a weekly table
3. **Three-level worksheet** — support, grade level and challenge
4. **Reading text at a level** — words, sentence length, sight words
5. **Word list for a topic** — key English words with simple meanings
6. **Exit ticket** — 3 questions to check learning
7. **Fix this plan** — follow-up prompts from the CHECK list

## Make each template complete

Each template should have **gaps in brackets** and **rules you always want**:

> You are an experienced [phase] teacher in a no-fee public school in the Eastern Cape. [Task]. Grade [ ], [subject], Term [ ], Week [ ]. ATP: "[ ]". Class: [number] learners, language of teaching [ ]. Resources: [ ]. Use simple English, South African names and examples, and rand for money. Keep it to one page. Do not include learners' personal information.

## Work with your phase

You are not alone. In **phase meetings** or **Professional Learning Communities (PLCs)**:

- share your best templates
- divide the work: one teacher plans Maths for the week, another plans Life Skills, then you all check and share
- discuss AI mistakes you found, so everyone learns

## Keep growing

AI tools change quickly. Keep practising in the **Noodle Playground**, try new tasks, and keep improving your toolkit.

## Key words

| Word | Simple meaning |
|---|---|
| Toolkit | Your saved set of prompts you use again and again |
| PLC | Professional Learning Community — teachers who meet to learn together |
| Phase meeting | A meeting of teachers who teach in the same phase |

**Remember:** Save your best prompts, share them with colleagues, and keep checking. AI drafts, the teacher decides.
$md$,
     $t$Write your own toolkit of at least 4 planning templates. Test one in the Noodle Playground. Share one template with a colleague in your phase.$t$);

    insert into public.quiz_questions (module_id, position, question, options, correct_index, explanation) values
    (m, 1, $t$When you use AI for weekly planning, what should you check first?$t$,
        $j$["That the plan is very long","That the plan covers the ATP for that week and nothing extra","That every day has a video","That the AI used difficult words"]$j$,
        1, $t$The weekly plan must match the ATP: everything that is in it, and nothing extra.$t$),
    (m, 2, $t$In the CHECK list, what does "K" (Kit) ask?$t$,
        $j$["Do I have the resources and the time?","Is the plan kind?","Is it a Grade K lesson?","Does it use a computer?"]$j$,
        0, $t$Kit means: can I really teach this with my resources in the time I have?$t$),
    (m, 3, $t$The AI's plan is 60 minutes but your lesson is 30 minutes. What is the best next step?$t$,
        $j$["Start a new chat and type everything again","Teach for 60 minutes","Throw away the plan","Send a follow-up prompt: \"Shorten this plan to 30 minutes.\""]$j$,
        3, $t$A follow-up prompt fixes one thing quickly without starting again.$t$),
    (m, 4, $t$What is a good way to work with AI planning in your phase?$t$,
        $j$["Keep all prompts secret","Let one teacher use AI for everyone without checking","Share templates and the mistakes you found in phase meetings or PLCs","Stop planning together"]$j$,
        2, $t$Sharing templates and mistakes helps the whole phase plan faster and better.$t$);
end
$seed$;
