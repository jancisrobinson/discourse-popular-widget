# Popular Topics Widget

A Discourse theme component that displays popular (top-ranked) topics on the forum homepage.

## Features

- Fetches topics from Discourse's `/top.json` endpoint
- Separate time period settings for logged-in and anonymous users
- Renders using Discourse's core `LatestTopicListItem` component for consistent styling
- Positioned between custom category boxes and the categories-and-latest section
- Hidden on mobile devices
- Translated "More" button linking to the full top topics page

## Settings

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `topic_count` | integer | 5 | Number of topics to display (3-10) |
| `period` | enum | quarterly | Time period for logged-in users |
| `period_anonymous` | enum | yearly | Time period for anonymous visitors |
| `widget_title` | string | Popular | Heading text above the topic list |
| `show_on_home` | bool | true | Toggle homepage visibility |

## Installation

1. Go to **Admin > Customize > Themes**
2. Click **Install** > **From a git repository**
3. Enter: `https://github.com/jancisrobinson/discourse-popular-widget.git`
4. Add the component to your active theme

## Requirements

- Discourse 3.1.0 or later

## License

[MIT](https://github.com/discourse/discourse/blob/main/LICENSE.txt)
