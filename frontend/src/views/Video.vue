<template>
  <div>
    <video-player :options="videoOptions" />
  </div>
</template>

<script>
import VideoPlayer from "@/components/VideoPlayer.vue";

export default {
  name: "VideoExample",
  components: {
    VideoPlayer,
  },
  data() {
    return {
      videoOptions: {
        autoplay: true,
        controls: true,
        sources: [
          {
            src: "/output/Starting Soon.m3u8",
            type: "application/x-mpegURL",
          },
        ],
      },
    };
  },
};
</script>
<style src="video.js/dist/video-js.css"></style>
