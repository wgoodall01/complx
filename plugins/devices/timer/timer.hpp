#ifndef TIMER_HPP
#define TIMER_HPP

#include <ctime>
#include <lc3_all.hpp>

#define TIMER_MAJOR_VERSION 1
#define TIMER_MINOR_VERSION 5

///TODO complete this plugin
class TimerPlugin : public DeviceRegisterPlugin
{
public:
    TimerPlugin(unsigned short address, unsigned char vector) : DeviceRegisterPlugin(TIMER_MAJOR_VERSION, TIMER_MINOR_VERSION, "Timer plugin", address, true, vector) {}
    short OnRead(lc3_state& state) override;
    void OnWrite(lc3_state& state, short value) override;
    void OnTick(lc3_state& state) override;
    time_t lastreadtime;
    time_t time;
};

extern "C" Plugin* create_plugin(const std::map<std::string, std::string>& params);
extern "C" void destroy_plugin(Plugin* ptr);

#endif

