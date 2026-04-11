# MultiQueryTestCase

Add multi-turn support to the `Web.Api.Console` test harness (`lpserver` repo). Today the framework supports only single-query test cases (one prompt → one response → evaluate). This change allows a test case file to simulate a real conversation: multiple sequential queries sent to the same session, each waiting for the previous to complete before the next is sent. The final response is evaluated against the test objective.

The change touches three source files and adds one new test case file:
- `Web.Api.Console/Runner/TestSuiteRunner.cs` — parse multi-turn prompts from the file
- `Web.Api.Console/Runner/TestCaseRunner.cs` — loop prompts through the same session
- `Web.Api.Console/TestCases/case-medigap-followup.txt` — new multi-turn test case

`ResponseEvaluator` and `ChatApiClient` require no changes. The `---` delimiter is invisible to single-prompt files, so existing test cases continue to work unchanged.

## Tasks

- id: task-1
  status: done
  description: >
    Update TestSuiteRunner to parse multi-turn prompts. After stripping comment lines,
    split the remaining content on lines that are exactly `---` to produce a `string[]`
    of prompts (trimming each block). A file with no `---` yields a one-element array,
    preserving backward compatibility. Pass the array to TestCaseRunner.RunAsync.
  dependencies: []

- id: task-2
  status: done
  description: >
    Update TestCaseRunner.RunAsync to accept `string[] prompts` instead of `string prompt`.
    Loop through prompts: call StartChatAsync for the first prompt (no sessionId),
    capture the returned sessionId, then call StartChatAsync(prompt, sessionId) for each
    subsequent prompt. Call PollUntilDoneAsync after each turn before sending the next.
    After the final turn completes, fetch dialog and evaluate as today, passing the last
    prompt as the userPrompt to ResponseEvaluator.EvaluateAsync. GetTaskZJudgementAsync
    should only be checked for the final turn.
  dependencies: [task-1]

- id: task-3
  status: pending
  description: >
    Create a new multi-turn test case file `Web.Api.Console/TestCases/case-medigap-followup.txt`.
    The first turn is a full retirement scenario prompt for a 55-year-old planning to retire at 60
    with $1,200,000 in a traditional IRA. The second turn (after `---`) is a follow-up:
    "how do I specify medigap costs?". The test objective comment should state that the second
    response must answer the Medigap question in plain English without exposing raw JSON.
    Add the new case to suite-all.txt.
  dependencies: [task-2]
