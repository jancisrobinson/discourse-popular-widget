import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { service } from "@ember/service";
import { modifier } from "ember-modifier";
import { ajax } from "discourse/lib/ajax";
import { apiInitializer } from "discourse/lib/api";
import TopicList from "discourse/models/topic-list";
import LatestTopicListItem from "discourse/components/topic-list/latest-topic-list-item";
import { i18n } from "discourse-i18n";

export default apiInitializer("1.0.0", (api) => {
  const currentUser = api.getCurrentUser();

  api.renderInOutlet("above-discovery-categories", class PopularTopicsWidget extends Component {
    @service store;
    @tracked topics = [];
    @tracked loading = true;

    constructor() {
      super(...arguments);
      if (this.shouldShow) {
        this.fetchTopics();
      }
    }

    get shouldShow() {
      return settings.show_on_home;
    }

    get period() {
      return currentUser ? settings.period : settings.period_anonymous;
    }

    positionAfterCategoryBoxes = modifier((element) => {
      const categoryBoxes = document.querySelector(".custom-category-boxes-container");
      if (categoryBoxes) {
        categoryBoxes.after(element);
      }
    });

    async fetchTopics() {
      try {
        const result = await ajax(`/top.json?period=${this.period}`);
        const allTopics = TopicList.topicsFrom(this.store, result);
        this.topics = allTopics.slice(0, settings.topic_count);
      } catch (e) {
        // eslint-disable-next-line no-console
        console.error("Popular topics widget: failed to fetch topics", e);
        this.topics = [];
      } finally {
        this.loading = false;
      }
    }

    <template>
      {{#if this.shouldShow}}
        {{#unless this.loading}}
          {{#if this.topics.length}}
            <div class="popular-topics-container" {{this.positionAfterCategoryBoxes}}>
              <div role="heading" aria-level="2" class="table-heading">{{settings.widget_title}}</div>
              <div class="latest-topic-list">
                {{#each this.topics as |topic|}}
                  <LatestTopicListItem @topic={{topic}} />
                {{/each}}
                <div class="more-topics">
                    <a href="/top" class="btn btn-default pull-right">{{i18n "more"}}</a>
                </div>
              </div>
            </div>
          {{/if}}
        {{/unless}}
      {{/if}}
    </template>
  });
});
