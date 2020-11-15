<template>
  <a class="list-group-item list-group-item-action flex-column align-items-start bg-transparent text-light" :href="`http://www.speedrunslive.com/race/?id=${value.id}`">
    <div class="d-flex w-100 justify-content-between">
      <h5>{{value.game.name}}</h5>
      <h5 v-if="value.statetext === 'In Progress'" :data-abstime="new Date(value.time * 1000).toISOString()" data-abstime-format="HH:mm:ss" />
      <h5 v-else-if="value.statetext === 'Entry Open'" class="text-success">Open</h5>
      <h5 v-else>{{value.statetext}}</h5>
    </div>
    <div class="d-flex w-100 justify-content-between">
      <span>{{value.goal}}</span>
      <span class="text-nowrap">{{value.numentrants}} entrants</span>
    </div>
  </a>
</template>

<script>
export default {
  props: ['value'],
}
</script>
