import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { apiInitializer } from "discourse/lib/api";
import TopicList from "discourse/models/topic-list";
import LatestTopicListItem from "discourse/components/topic-list/latest-topic-list-item";

export default apiInitializer("1.0.0", (api) => {
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

    async fetchTopics() {
      try {
        const result = await ajax(`/top.json?period=${settings.period}`);
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
            <div class="popular-topics-container">
              <h3 class="popular-topics-title">
                <a href="/top?period={{settings.period}}">{{settings.widget_title}}</a>
              </h3>
              <div class="latest-topic-list">
                {{#each this.topics as |topic|}}
                  <LatestTopicListItem @topic={{topic}} />
                {{/each}}
              </div>
            </div>
          {{/if}}
        {{/unless}}
      {{/if}}
    </template>
  });
});
