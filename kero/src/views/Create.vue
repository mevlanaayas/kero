<template>
  <el-form ref="form" :model="form" label-width="120px" v-loading="pending">
    <el-form-item label="Activity Name">
      <el-input v-model="form.activityName"></el-input>
    </el-form-item>

    <el-form-item>
      <el-checkbox v-on:change="free($event)">Free</el-checkbox>
    </el-form-item>

    <el-form-item>
      <el-checkbox v-model="form.isActive">Is Active</el-checkbox>
    </el-form-item>

    <el-form-item label="Ticket Price">
      <el-input
        v-model="form.price"
        type="number"
        placeholder="milli ether"
      ></el-input>
    </el-form-item>

    <el-form-item label="Participant Limit">
      <el-input v-model="form.participantLimit" type="number"></el-input>
    </el-form-item>

    <el-form-item>
      <el-date-picker
        v-model="form.date"
        type="date"
        placeholder="Pick a day"
        :picker-options="pickerOptions"
      >
      </el-date-picker>
    </el-form-item>

    <el-form-item label="Agenda-Content">
      <el-input type="textarea" v-model="form.content"></el-input>
    </el-form-item>
    <el-form-item>
      <el-button type="primary" @click="createActivity"
        >Create Activity
      </el-button>
      <el-button>Cancel</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
import store from "../store/index";

window.depo = {
  web3: store
};

export default {
  name: "Create",
  data() {
    return {
      form: {
        activityName: "",
        isActive: null,
        price: null,
        date: new Date(),
        participantLimit: null,
        content: null
      },
      c_instance: null,
      coinbase: null,
      activity_list: null,
      isActivePrice: true,
      pending: false,
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() > Date.now();
        },
        shortcuts: [
          {
            text: "Today",
            onClick(picker) {
              picker.$emit("pick", new Date());
            }
          },
          {
            text: "Yesterday",
            onClick(picker) {
              const date = new Date();
              date.setTime(date.getTime() - 3600 * 1000 * 24);
              picker.$emit("pick", date);
            }
          },
          {
            text: "A week ago",
            onClick(picker) {
              const date = new Date();
              date.setTime(date.getTime() - 3600 * 1000 * 24 * 7);
              picker.$emit("pick", date);
            }
          }
        ]
      }
    };
  },
  computed: {
    getDate: function() {
      return this.toTimestamp(this.form.date);
    }
  },
  mounted() {
    this.c_instance = this.$store.getters.contract();
    this.coinbase = this.$store.getters.currentAddress;
  },
  methods: {
    toTimestamp(strDate) {
      let datum = Date.parse(strDate);
      return datum / 1000;
    },
    free(value) {
      if (value) {
        this.isActivePrice = false;
        this.form.price = 0;
      } else {
        this.isActivePrice = true;
      }
    },
    createActivity() {
      let _base = this.coinbase;
      const temp = this.c_instance.methods
        .createActivity(
          this.form.activityName,
          this.form.participantLimit,
          this.form.price,
          this.toTimestamp(this.form.date),
          this.form.content
        )
        .send({
          value: this.$options.filters.toWei("0.1"),
          from: _base,
          gas: 4500000
        });
      this.pending = true;
      let self = this;
      temp.then(function(error, value) {
        if (error) {
          console.log(error);
        } else {
          console.log(value);
        }
        self.pending = false;
      });
    }
  }
};
</script>
