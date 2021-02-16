<template>
  <div>
    <activity></activity>
    {{ newActivities }}
    {{ activities }}
    {{ pastActivities }}
  </div>
</template>

<script>
import store from "../store/index";
import Activity from "./Activity";
window.depo = {
  web3: store
};
export default {
  name: "Activities",
  components: {
    activity: Activity
  },
  data: function() {
    return {
      newActivities: [],
      activities: [],
      pastActivities: []
    };
  },
  mounted() {
    let _contract = this.$store.getters.contract();

    _contract.getPastEvents(
      "ActivityCreated",
      { fromBlock: 0, toBlock: "latest" },
      (err, event) => {
        let number = 0;
        event.forEach(element => {
          element = element.returnValues;
          const temp = _contract.methods.getInfoActivity(element._owner).call();
          temp.then(
            function(val) {
              console.log(val);
              var date = new Date(parseInt(val[6]) * 1000);
              var daysDiff = Math.floor(
                (new Date() - date) / (1000 * 60 * 60 * 24)
              );
              if (val[2] === true) {
                number += 1;
                this.activities.push({
                  name: val[0],
                  key: number,
                  address: val[1],
                  limit: val[5],
                  content: val[7],
                  imageHash: val[8]
                });
              } else {
                number += 1;
                this.pastActivities.push({
                  name: val[0],
                  key: number,
                  address: val[1],
                  limit: val[5],
                  content: val[7],
                  imageHash: val[8]
                });
              }
              if (daysDiff < 7) {
                number += 1;
                this.newActivities.push({
                  name: val[0],
                  key: number,
                  address: val[1],
                  limit: val[5],
                  content: val[7],
                  imageHash: val[8]
                });
              }
            }.bind(this)
          );
        });
      }
    );
  }
};
</script>
