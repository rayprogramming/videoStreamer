import { expect } from "chai";
import { shallowMount } from "@vue/test-utils";
import LoginForm from "@/components/LoginForm.vue";

describe("LoginForm.vue", () => {
  it("renders email field when passed", () => {
    const wrapper = shallowMount(LoginForm);
    expect(wrapper.find("#email")).to.exist;
  });
  it("should have props for email and password", () => {
    const wrapper = shallowMount(LoginForm);
    expect(wrapper.props("email")).to.exist;
    expect(wrapper.props("password")).to.exist;
  });
});
